# Defensa técnica — Laboratorio 1

## 1. Estado y ubicación

El estado vive en `_AttendanceScreenState`, en `lib/main.dart`: la lista `students`.

Está ahí porque es el punto más bajo del árbol desde donde se ve todo lo que depende de esa lista: el contador de presentes del encabezado, los botones "Marcar todos" y "Restablecer", y el `ListView.builder`. Los cuatro consumen la misma información. Bajarlo un nivel la fragmenta; subirlo a `AttendanceApp` lo eleva sin que nadie más lo use. Desde ahí, `setState` reconstruye exactamente el subárbol que depende del dato y nada más.

Lo de alrededor es sin estado a propósito. `AttendanceApp` y `StudentTile` son `StatelessWidget`: el tile recibe un `Student` y un `VoidCallback`, y no guarda nada propio.

**Consecuencia de ponerlo en otra parte.** Si cada `StudentTile` fuera un `StatefulWidget` con su propio `bool present`, el encabezado quedaría desconectado: al mover un switch, el tile se repintaría pero el contador seguiría mostrando el valor viejo, porque el estado que cambió no vive en el widget que lo muestra. Y "Marcar todos" no tendría a quién ordenarle nada —cada tile sería dueño de su propio dato— así que habría que reintroducir el estado compartido por otra vía. El problema no se elimina, se traslada.

El otro lugar tentador es peor: mutar `initialStudents` directamente. Está declarada `final`, pero `final` congela la referencia, no el contenido: los `Student` de adentro tienen `present` mutable. Tocar un switch ensuciaría la semilla de forma permanente dentro del proceso.

Eso rompe los tests de forma concreta. Los tests de un mismo archivo corren en un solo isolate y esa global se inicializa una única vez, así que un test que marque a un alumno filtra ese valor al siguiente: el segundo esperaría `Presentes: 0 / 12` y encontraría `1 / 12`. Falla o pasa según el orden de ejecución, que es el peor tipo de inestabilidad.

Por eso `_copyInitialStudents()` construye objetos `Student` nuevos con `map`, y no un `List.from`. Una copia superficial duplicaría la lista pero compartiría los mismos objetos, y el bug quedaría idéntico. Y por eso `resetStudents()` puede releer la semilla con confianza: nunca se ensucia.

## 2. Reconstrucción de widgets

Al tocar un `Switch`, el `onChanged` del tile dispara el callback que le pasó el padre, que llama a `toggleStudent(index)`, que llama a `setState`.

Lo que se vuelve a ejecutar es el `build()` completo de `_AttendanceScreenState`: `AppBar`, encabezado, botones, `Divider` y `ListView`. `setState` no tiene granularidad más fina que eso — su unidad es el `State` entero.

Y los tiles se reconstruyen todos, no solo el que toqué. El `itemBuilder` se vuelve a llamar para cada índice vivo y devuelve un `StudentTile` nuevo. Los once que no cambiaron hacen el mismo trabajo que el que cambió.

**¿Qué hice para evitarlo?** Poco, y de forma deliberada.

Los `const` del encabezado (`Text('Grupo 01')`, los `SizedBox`, el `Divider`) sí cortan trabajo real: son instancias canónicas, y cuando Flutter compara el widget viejo con el nuevo y encuentra que son idénticos por identidad, no desciende a reconciliar ese subárbol. El analizador me los señaló, pero el efecto es genuino, no cosmético.

Más allá de eso, no hay keys, ni `RepaintBoundary`, ni estado por tile. `ListView.builder` construye solo los visibles más un margen de caché en vez de los doce de golpe, pero con doce alumnos eso casi no se ejercita: entran casi todos en pantalla. El beneficio aparece con cientos de ítems.

No lo optimicé más porque acá no hace falta. Los widgets son objetos de configuración inmutables y baratos de crear; la capa de render solo repinta lo que de verdad cambió, que es el texto del contador y un `Switch`. El desperdicio está en la capa de widgets y es de microsegundos.

Si la lista creciera a miles de registros, la salida no sería mover el estado a cada tile —eso desconectaría el contador, que es exactamente el problema de la pregunta 1—, sino mantenerlo centralizado y cortar la propagación: extraer cada fila a un widget que escuche solo su propio registro, con `ValueListenableBuilder` o un gestor de estado que permita suscripciones por ítem. El estado sigue siendo uno; lo que cambia es quién se entera.

## 3. Extracción de componente

Extraje `StudentTile` (`lib/widgets/student_tile.dart`): un `StatelessWidget` que recibe un `Student` y un `VoidCallback`, y devuelve la fila con nombre, carné y `Switch`.

**Criterio:** repetición más contrato angosto. Es lo que aparece doce veces, y su interfaz es mínima —entra un alumno, sale una fila— sin saber nada del resto de la pantalla. No accede al estado del padre: solo consume lo que recibe y avisa hacia arriba por el callback.

No extraje el encabezado: aparece una sola vez y está pegado a los callbacks del State. Ahí extraer sería ceremonia sin beneficio.

**Método vs. clase.** Un método es una llamada dentro del `build` del padre: se ejecuta siempre, y lo que devuelve queda como hijo directo del padre. No existe un elemento `StudentTile` en el árbol. Una clase infla su propio elemento — un nodo con identidad.

Eso importa en `updateChild`, donde ocurre la reconciliación. Lo primero que hace Flutter es comparar el widget nuevo con el viejo; si son idénticos, no llama a `update` y el subárbol no se reconstruye. Corta ahí.

Con una clase existe un objeto que puede entrar en esa comparación. Con un método no puede existir: no hay nada que represente al tile, porque el cuerpo ya corrió como parte del `build` del padre. El cuerpo de un método nunca se puede saltear, porque ejecutarlo es lo que produce los widgets. El `build` de una clase es una llamada aparte, y por lo tanto salteable.

**Siendo honesto: en mi código nunca se saltea.** Por dos razones, no una. El `onChanged` es un closure que se crea nuevo en cada build, así que la comparación da falso. Y aunque fuera estable, `StudentTile` tampoco podría construirse como `const` en el `itemBuilder`, porque `student` sale de una lista que existe en runtime. El constructor es `const` y acepta `key`, o sea que la costura está preparada — pero hoy no corta. Lo que gané con la clase es la posibilidad de cortar, no el corte.

**Lo que sí gano hoy es estructural:**

- Un lugar donde poner estado y ciclo de vida si el tile llegara a necesitarlos, sin tocar la pantalla.
- Un nodo propio donde colgar una `Key` — necesario si la lista se reordenara o filtrara, para que Flutter siga a cada fila en vez de reasignar por posición.
- Un `BuildContext` propio: si el tile necesitara su `Theme`, un `MediaQuery` o mostrar un diálogo, resuelve desde su posición real en el árbol. Con un método, el context es el del padre, y cualquier widget que el tile introdujera por encima de sí mismo sería invisible para esa búsqueda.
- Un límite de prueba: puedo montar `StudentTile` solo en un test de widget. Un método privado del State no es testeable por separado.

## Registro de consultas a IA

Se utilizó IA durante el desarrollo de este laboratorio. Detalle:

**Código base** — sin IA
`lib/main.dart`, `lib/models/student.dart`, `lib/data/student_data.dart` y `lib/widgets/student_tile.dart` fueron escritos a mano por el equipo. La estructura del proyecto (estado centralizado, extracción de `StudentTile`, separación de datos y presentación) es decisión propia.

**Revisión contra la rúbrica** — Claude (claude.ai)
Se le proporcionaron las diapositivas del laboratorio y el código fuente. Identificó tres hallazgos:

- `test/widget_test.dart` seguía siendo el del scaffold y referenciaba `MyApp`, clase inexistente. `flutter analyze` habría reportado error, incumpliendo el criterio de buenas prácticas.
- `resetStudents()` ponía `present = false` en todos los registros en lugar de restaurar el estado inicial. Funcionaba por coincidencia, ya que todos los registros semilla arrancan en `false`.
- Import con ruta absoluta (`'/models/student.dart'`) inconsistente con el resto del proyecto.

**Corrección de esos tres hallazgos** — Claude (claude.ai)
Escribió el contenido completo de `test/widget_test.dart`, el método `_copyInitialStudents()` y la nueva versión de `resetStudents()`. Se aplicaron manualmente al repositorio y se verificaron con `flutter analyze` (sin hallazgos) y `flutter test` (1/1). Commit `fc40a24`.

**Redacción de este archivo** — Claude (claude.ai)
Las tres respuestas se escribieron primero como borrador propio y luego se editaron con asistencia de la IA, que corrigió dos puntos de fondo: el borrador original describía el uso de `const` como cosmético (es una optimización real, ya que la canonicalización permite cortar la reconciliación por identidad), y proponía distribuir el estado por tile como solución a escala (lo que desconectaría el contador, contradiciendo la respuesta 1).

No se consultó ninguna otra herramienta de IA.
