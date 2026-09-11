# Guía paso a paso --- Práctica Flutter: Lista dinámica y estado local

> **Objetivo:** construir la pantalla de control de asistencia
> solicitada en las diapositivas de la práctica.
>
> La práctica exige una lista con mínimo 12 registros, contador de
> presentes, acciones globales, `ListView.builder`, estado centralizado
> en un único `StatefulWidget`, un componente extraído como clase y
> separación entre datos y presentación. También debe funcionar a 360 px
> sin desbordamientos.

------------------------------------------------------------------------

# PARTE 1 --- Crear el proyecto

## Paso 1. Crear el proyecto

Abre una terminal en la carpeta donde quieras guardar el proyecto y
ejecuta:

``` bash
flutter create asistencia_app
```

Después entra al proyecto:

``` bash
cd asistencia_app
```

Ábrelo en VS Code:

``` bash
code .
```

------------------------------------------------------------------------

# PARTE 2 --- Qué archivos vamos a usar

La estructura final que tendrás será:

``` text
asistencia_app/
│
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── student.dart
│   ├── data/
│   │   └── students_data.dart
│   └── widgets/
│       └── student_tile.dart
│
├── test/
├── android/
├── ios/
├── web/
├── windows/
├── linux/
├── macos/
├── pubspec.yaml
└── ...
```

Para esta práctica solamente vamos a modificar/crear principalmente:

``` text
lib/main.dart
lib/models/student.dart
lib/data/students_data.dart
lib/widgets/student_tile.dart
```

Y crearemos:

``` text
DEFENSA.md
```

en la raíz del proyecto.

------------------------------------------------------------------------

# PARTE 3 --- Qué borrar y qué conservar

## Paso 2. No borres toda la carpeta del proyecto

NO borres:

``` text
android/
ios/
web/
windows/
linux/
macos/
pubspec.yaml
```

Flutter necesita esos archivos/carpetas para ejecutar el proyecto.

------------------------------------------------------------------------

## Paso 3. Borrar el contenido inicial de `lib/main.dart`

Abre:

``` text
lib/main.dart
```

Selecciona **todo el contenido** y bórralo.

No vamos a reutilizar la aplicación de contador que Flutter crea
automáticamente.

Al final, `main.dart` quedará vacío temporalmente.

------------------------------------------------------------------------

# PARTE 4 --- Crear el modelo Student

## Paso 4. Crear la carpeta `models`

Dentro de:

``` text
lib/
```

crea una carpeta llamada:

``` text
models
```

Quedará:

``` text
lib/
└── models/
```

------------------------------------------------------------------------

## Paso 5. Crear `student.dart`

Dentro de:

``` text
lib/models/
```

crea:

``` text
student.dart
```

Ruta completa:

``` text
lib/models/student.dart
```

------------------------------------------------------------------------

## Paso 6. Escribir el modelo

En `lib/models/student.dart` coloca:

``` dart
class Student {
  final String name;
  final String carnet;
  bool present;

  Student({
    required this.name,
    required this.carnet,
    this.present = false,
  });
}
```

### ¿Qué contiene este archivo?

Este archivo solamente define qué es un estudiante.

Tiene:

``` dart
name
```

para el nombre.

``` dart
carnet
```

para el carné.

``` dart
present
```

para saber si está presente.

El archivo NO contiene widgets.

------------------------------------------------------------------------

# PARTE 5 --- Crear los datos de estudiantes

## Paso 7. Crear la carpeta `data`

Dentro de:

``` text
lib/
```

crea:

``` text
data
```

Quedará:

``` text
lib/
├── data/
└── models/
```

------------------------------------------------------------------------

## Paso 8. Crear `students_data.dart`

Dentro de:

``` text
lib/data/
```

crea:

``` text
students_data.dart
```

Ruta:

``` text
lib/data/students_data.dart
```

------------------------------------------------------------------------

## Paso 9. Colocar los estudiantes

En `students_data.dart` coloca:

``` dart
import '../models/student.dart';

final List<Student> initialStudents = [
  Student(name: 'Ana López', carnet: '001'),
  Student(name: 'Carlos Pérez', carnet: '002'),
  Student(name: 'María García', carnet: '003'),
  Student(name: 'José Martínez', carnet: '004'),
  Student(name: 'Sofía Hernández', carnet: '005'),
  Student(name: 'Daniel Rodríguez', carnet: '006'),
  Student(name: 'Laura Sánchez', carnet: '007'),
  Student(name: 'Miguel Torres', carnet: '008'),
  Student(name: 'Valeria Flores', carnet: '009'),
  Student(name: 'Andrés Ramírez', carnet: '010'),
  Student(name: 'Gabriela Cruz', carnet: '011'),
  Student(name: 'Fernando Morales', carnet: '012'),
];
```

Puedes cambiar los nombres y carnés por los que quieras.

### Importante

Los datos están aquí y **no dentro del `build()`**.

Eso permite cumplir la separación entre datos y presentación indicada en
la práctica.

------------------------------------------------------------------------

# PARTE 6 --- Crear el widget de cada estudiante

La práctica solicita al menos un widget extraído como clase
independiente y que los datos entren mediante el constructor.

## Paso 10. Crear la carpeta `widgets`

Dentro de:

``` text
lib/
```

crea:

``` text
widgets
```

Quedará:

``` text
lib/
├── data/
├── models/
└── widgets/
```

------------------------------------------------------------------------

## Paso 11. Crear `student_tile.dart`

Dentro de:

``` text
lib/widgets/
```

crea:

``` text
student_tile.dart
```

Ruta:

``` text
lib/widgets/student_tile.dart
```

------------------------------------------------------------------------

## Paso 12. Colocar el código de `StudentTile`

En ese archivo coloca:

``` dart
import 'package:flutter/material.dart';

import '../models/student.dart';

class StudentTile extends StatelessWidget {
  final Student student;
  final VoidCallback onChanged;

  const StudentTile({
    super.key,
    required this.student,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(student.name),
      subtitle: Text('Carné: ${student.carnet}'),
      trailing: Switch(
        value: student.present,
        onChanged: (_) => onChanged(),
      ),
    );
  }
}
```

------------------------------------------------------------------------

## ¿Qué hace este archivo?

`StudentTile` representa **una fila de un estudiante**.

Visualmente:

``` text
Ana López             [switch]
Carné: 001
```

El widget recibe:

``` dart
final Student student;
```

y:

``` dart
final VoidCallback onChanged;
```

No contiene la lista completa.

Tampoco modifica directamente el `State` de la pantalla.

------------------------------------------------------------------------

# PARTE 7 --- Crear la pantalla principal

Ahora vamos a utilizar los archivos anteriores desde `main.dart`.

## Paso 13. Abrir `lib/main.dart`

Recuerda que anteriormente borramos todo su contenido.

Ahora coloca **todo este código**:

``` dart
import 'package:flutter/material.dart';

import 'data/students_data.dart';
import 'models/student.dart';
import 'widgets/student_tile.dart';

void main() {
  runApp(const AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AttendanceScreen(),
    );
  }
}

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late List<Student> students;

  @override
  void initState() {
    super.initState();

    students = initialStudents
        .map(
          (student) => Student(
            name: student.name,
            carnet: student.carnet,
            present: student.present,
          ),
        )
        .toList();
  }

  int get presentCount {
    return students.where((student) => student.present).length;
  }

  void toggleStudent(int index) {
    setState(() {
      students[index].present = !students[index].present;
    });
  }

  void markAllPresent() {
    setState(() {
      for (final student in students) {
        student.present = true;
      }
    });
  }

  void resetStudents() {
    setState(() {
      for (final student in students) {
        student.present = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control de asistencia'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Grupo 01',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Presentes: $presentCount / ${students.length}',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: markAllPresent,
                          child: const Text('Marcar todos'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: resetStudents,
                          child: const Text('Restablecer'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];

                  return StudentTile(
                    student: student,
                    onChanged: () => toggleStudent(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

------------------------------------------------------------------------

# PARTE 8 --- Entender dónde está cada cosa

En este punto ya tienes cuatro archivos importantes.

## `lib/models/student.dart`

Contiene:

``` text
Modelo Student
```

Es decir, la estructura de los datos.

------------------------------------------------------------------------

## `lib/data/students_data.dart`

Contiene:

``` text
Lista inicial de estudiantes
```

Aquí están los 12 registros.

------------------------------------------------------------------------

## `lib/widgets/student_tile.dart`

Contiene:

``` text
StudentTile
```

Es la representación visual de un estudiante.

------------------------------------------------------------------------

## `lib/main.dart`

Contiene:

``` text
AttendanceApp
AttendanceScreen
_​AttendanceScreenState
```

Aquí vive el estado de la pantalla y las funciones que lo modifican.

------------------------------------------------------------------------

# PARTE 9 --- Cómo funciona el estado

La variable:

``` dart
late List<Student> students;
```

está dentro de:

``` dart
class _AttendanceScreenState extends State<AttendanceScreen>
```

Por lo tanto, el estado de la pantalla está centralizado allí.

------------------------------------------------------------------------

## Cambiar un estudiante

Esta función:

``` dart
void toggleStudent(int index) {
  setState(() {
    students[index].present = !students[index].present;
  });
}
```

hace tres cosas:

1.  Encuentra el estudiante mediante `index`.
2.  Invierte su estado `present`.
3.  Utiliza `setState` para indicar que la interfaz debe actualizarse.

------------------------------------------------------------------------

# PARTE 10 --- Cómo funciona el contador

Este getter:

``` dart
int get presentCount {
  return students.where((student) => student.present).length;
}
```

cuenta cuántos estudiantes tienen:

``` dart
present == true
```

Luego se utiliza aquí:

``` dart
Text(
  'Presentes: $presentCount / ${students.length}',
)
```

Por ejemplo:

``` text
Presentes: 4 / 12
```

------------------------------------------------------------------------

# PARTE 11 --- Cómo funciona `ListView.builder`

En `main.dart` busca:

``` dart
Expanded(
  child: ListView.builder(
```

La lista utiliza:

``` dart
itemCount: students.length,
```

y para cada posición obtiene:

``` dart
final student = students[index];
```

Después crea:

``` dart
StudentTile(
  student: student,
  onChanged: () => toggleStudent(index),
)
```

La comunicación queda:

``` text
ListView.builder
       ↓
StudentTile
       ↓
onChanged
       ↓
toggleStudent(index)
       ↓
setState
       ↓
actualización de la pantalla
```

------------------------------------------------------------------------

# PARTE 12 --- Cómo funcionan los botones globales

## Botón "Marcar todos"

En `main.dart`:

``` dart
ElevatedButton(
  onPressed: markAllPresent,
  child: const Text('Marcar todos'),
)
```

La función está arriba:

``` dart
void markAllPresent() {
  setState(() {
    for (final student in students) {
      student.present = true;
    }
  });
}
```

------------------------------------------------------------------------

## Botón "Restablecer"

En `main.dart`:

``` dart
OutlinedButton(
  onPressed: resetStudents,
  child: const Text('Restablecer'),
)
```

La función:

``` dart
void resetStudents() {
  setState(() {
    for (final student in students) {
      student.present = false;
    }
  });
}
```

------------------------------------------------------------------------

# PARTE 13 --- Ejecutar la aplicación

Desde la raíz del proyecto:

``` bash
flutter run
```

Si utilizas Chrome:

``` bash
flutter run -d chrome
```

------------------------------------------------------------------------

# PARTE 14 --- Probar cada requisito

## Prueba 1 --- Inicio

Al iniciar debería aparecer:

``` text
Control de asistencia

Grupo 01
Presentes: 0 / 12

[Marcar todos] [Restablecer]

Ana López
Carné: 001                         [OFF]

...
```

------------------------------------------------------------------------

## Prueba 2 --- Cambiar un estudiante

Pulsa el switch de Ana.

Debe cambiar:

``` text
Presentes: 0 / 12
```

a:

``` text
Presentes: 1 / 12
```

------------------------------------------------------------------------

## Prueba 3 --- Cambiar otro

Activa otro estudiante.

Debe pasar a:

``` text
Presentes: 2 / 12
```

------------------------------------------------------------------------

## Prueba 4 --- Marcar todos

Pulsa:

``` text
Marcar todos
```

Resultado esperado:

``` text
Presentes: 12 / 12
```

Todos los switches deben quedar activos.

------------------------------------------------------------------------

## Prueba 5 --- Restablecer

Pulsa:

``` text
Restablecer
```

Resultado esperado:

``` text
Presentes: 0 / 12
```

Todos deben volver al estado inicial.

------------------------------------------------------------------------

# PARTE 15 --- Probar el ancho de 360 px

La práctica especifica que la aplicación debe funcionar correctamente a
**360 px de ancho**.

Prueba la aplicación en un dispositivo/emulador de aproximadamente:

``` text
360 x 800
```

Revisa especialmente:

-   Los dos botones.
-   El título.
-   Los nombres.
-   Los carnés.
-   Los switches.
-   La lista.

No debe aparecer:

``` text
A RenderFlex overflowed by ... pixels
```

Si aparece un overflow horizontal, normalmente debes revisar los widgets
que están dentro de un `Row`.

------------------------------------------------------------------------

# PARTE 16 --- Ejecutar `flutter analyze`

Desde la raíz:

``` bash
flutter analyze
```

El objetivo es:

``` text
No issues found!
```

Si aparecen problemas, corrígelos antes de considerar terminada la
práctica.

------------------------------------------------------------------------

# PARTE 17 --- Qué hacer si `flutter analyze` señala `const`

La práctica pide utilizar correctamente `const`.

Por ejemplo, esto puede ser constante:

``` dart
const SizedBox(height: 8)
```

y:

``` dart
const Text('Marcar todos')
```

Pero un widget que utiliza información que cambia no debe convertirse
artificialmente en `const`.

Por ejemplo:

``` dart
Text(
  'Presentes: $presentCount / ${students.length}',
)
```

depende del estado y debe actualizarse.

------------------------------------------------------------------------

# PARTE 18 --- Crear `DEFENSA.md`

Ahora crea un archivo nuevo en la **raíz del proyecto**, no dentro de
`lib`.

La estructura será:

``` text
asistencia_app/
├── lib/
├── DEFENSA.md
├── pubspec.yaml
└── ...
```

## Paso 1

Haz clic derecho sobre la carpeta principal:

``` text
asistencia_app
```

Selecciona:

``` text
New File
```

y escribe:

``` text
DEFENSA.md
```

------------------------------------------------------------------------

# PARTE 19 --- Contenido recomendado para `DEFENSA.md`

Puedes utilizar esta estructura y adaptarla para que describa
exactamente tu implementación:

``` markdown
# Defensa técnica

## 1. Estado y ubicación

El estado de la pantalla vive en `_AttendanceScreenState`, que es el
State asociado al único `StatefulWidget` principal, `AttendanceScreen`.

La lista `students` contiene el estado actual de los estudiantes y se
modifica mediante `setState`.

La razón de colocar el estado allí es que la pantalla necesita reaccionar
a cambios producidos por la interacción del usuario. Al utilizar
`setState`, Flutter sabe que debe actualizar la interfaz asociada a ese
estado.

Una consecuencia de colocar este estado en una ubicación que no controle
la pantalla sería dificultar la actualización coherente de la interfaz y
separar el estado del widget que depende directamente de él.


## 2. Reconstrucción de widgets

Cuando el usuario cambia un solo registro se ejecuta `toggleStudent`,
que modifica el valor `present` dentro de `setState`.

Al llamar a `setState`, Flutter vuelve a ejecutar el `build` asociado al
State para obtener la configuración actualizada de la interfaz.

La lista utiliza `ListView.builder`, que construye los elementos de la
lista bajo demanda.

No implementé una estrategia adicional de gestión avanzada de
reconstrucciones porque el alcance de esta práctica utiliza un único
StatefulWidget para centralizar el estado.


## 3. Extracción de componente

El componente extraído fue `StudentTile`.

Lo extraje porque una fila de estudiante constituye una unidad visual
independiente que se repite para cada registro.

`StudentTile` recibe un objeto `Student` y un callback `onChanged` mediante
su constructor.

El componente no accede directamente al estado de `_AttendanceScreenState`.
La pantalla principal mantiene el estado y le proporciona al componente
la información y la acción que debe ejecutar.

Si se hubiera utilizado solamente un método que retorna un widget, la
interfaz podría haberse separado visualmente, pero no se habría creado una
clase de widget independiente con su propia interfaz mediante propiedades
del constructor.
```

> **Importante:** no afirmes en la defensa que hiciste una optimización
> que realmente no hiciste. La respuesta debe coincidir con tu código.

------------------------------------------------------------------------

# PARTE 20 --- Registro de uso de IA

Si esta práctica se está utilizando como ejercicio libre y quieres
documentar el uso de IA, puedes agregar al final de `DEFENSA.md` una
sección como:

``` markdown
## Registro de consultas a IA

Durante la realización de esta práctica se utilizaron consultas a una
herramienta de inteligencia artificial para comprender y desarrollar
la solución.

### Consulta 1
[Escribir aquí la consulta realizada.]

### Consulta 2
[Escribir aquí la consulta realizada.]

### Consulta 3
[Escribir aquí la consulta realizada.]
```

Si no utilizaste IA:

``` markdown
## Registro de consultas a IA

No se realizaron consultas a herramientas de inteligencia artificial
durante la realización de la práctica.
```

------------------------------------------------------------------------

# PARTE 21 --- Estructura final completa

Al terminar, tu proyecto debería verse aproximadamente así:

``` text
asistencia_app/
│
├── lib/
│   │
│   ├── main.dart
│   │
│   ├── models/
│   │   └── student.dart
│   │
│   ├── data/
│   │   └── students_data.dart
│   │
│   └── widgets/
│       └── student_tile.dart
│
├── test/
│
├── android/
├── ios/
├── web/
├── windows/
├── linux/
├── macos/
│
├── DEFENSA.md
├── pubspec.yaml
└── ...
```

------------------------------------------------------------------------

# PARTE 22 --- Qué NO necesitas crear

Para esta práctica NO necesitas crear:

``` text
services/
api/
repositories/
database/
controllers/
providers/
screens/
routes/
```

La práctica específicamente indica que no forman parte del alcance:

-   Persistencia de datos.
-   Navegación entre pantallas.
-   Consumo de servicios externos.

No agregues complejidad innecesaria.

------------------------------------------------------------------------

# PARTE 23 --- Checklist final

## Archivos

-   [ ] `lib/main.dart` reemplazó el código de contador original.
-   [ ] Existe `lib/models/student.dart`.
-   [ ] Existe `lib/data/students_data.dart`.
-   [ ] Existe `lib/widgets/student_tile.dart`.
-   [ ] Existe `DEFENSA.md` en la raíz.

## Datos

-   [ ] Hay mínimo 12 estudiantes.
-   [ ] Cada estudiante tiene nombre.
-   [ ] Cada estudiante tiene carné.
-   [ ] Cada estudiante tiene estado `present`.

## Funcionalidad

-   [ ] Se puede marcar un estudiante.
-   [ ] Se puede desmarcar.
-   [ ] El contador se actualiza.
-   [ ] "Marcar todos" funciona.
-   [ ] "Restablecer" funciona.
-   [ ] La lista se desplaza.

## Flutter

-   [ ] La pantalla principal es `StatefulWidget`.
-   [ ] El estado está en `_AttendanceScreenState`.
-   [ ] Los cambios utilizan `setState`.
-   [ ] Se utiliza `ListView.builder`.
-   [ ] Existe `StudentTile` como clase independiente.
-   [ ] `StudentTile` recibe datos por constructor.
-   [ ] Los datos están separados de la presentación.
-   [ ] Se utiliza `const` donde corresponde.

## Layout

-   [ ] Probado a 360 px.
-   [ ] No hay overflow.
-   [ ] Los botones caben.
-   [ ] La lista ocupa correctamente el espacio disponible.

## Análisis

Ejecutar:

``` bash
flutter analyze
```

Y comprobar que no existan problemas.

## Defensa

-   [ ] `DEFENSA.md` está en la raíz.
-   [ ] Pregunta 1 respondida.
-   [ ] Pregunta 2 respondida.
-   [ ] Pregunta 3 respondida.
-   [ ] La defensa coincide con el código real.
-   [ ] Registro de consultas de IA incluido si corresponde.

------------------------------------------------------------------------

# PARTE 24 --- Orden recomendado para hacerlo sin perderse

Si vas a seguir la práctica desde cero, haz exactamente este orden:

``` text
1. Crear proyecto
       ↓
2. Abrir proyecto en VS Code
       ↓
3. Vaciar lib/main.dart
       ↓
4. Crear lib/models/student.dart
       ↓
5. Crear lib/data/students_data.dart
       ↓
6. Crear lib/widgets/student_tile.dart
       ↓
7. Completar lib/main.dart
       ↓
8. Ejecutar flutter run
       ↓
9. Probar switches
       ↓
10. Probar "Marcar todos"
       ↓
11. Probar "Restablecer"
       ↓
12. Probar ancho 360 px
       ↓
13. Ejecutar flutter analyze
       ↓
14. Crear DEFENSA.md
       ↓
15. Revisar checklist
       ↓
16. Entregar
```

Con esta estructura, cada parte del código tiene un lugar específico y
no necesitas modificar archivos de Flutter que no participan
directamente en la práctica.
