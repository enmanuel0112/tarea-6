# MultiTool ITLA

Aplicación móvil académica para consultar herramientas y servicios web desde una interfaz Flutter con Material 3.

**Autor:** Cesar Ogando  
**Matrícula:** 2024-2485

## Módulos

- Predicción de género (Genderize)
- Persona aleatoria (Random User)
- Universidades
- Clima de Santo Domingo (Open-Meteo)
- Pokémon (PokéAPI)
- Noticias de WordPress.org
- Acerca de

## APIs utilizadas

- Genderize: `https://api.genderize.io/?name={nombre}`
- Random User: `https://randomuser.me/api/?results=1`
- Universidades: `https://adamix.net/proxy.php?country={pais}`
- Open-Meteo: `https://api.open-meteo.com/v1/forecast`
- PokéAPI: `https://pokeapi.co/api/v2/pokemon/{nombre}`
- WordPress API: `https://wordpress.org/news/wp-json/wp/v2/posts?per_page=3&_fields=id,date,link,title,excerpt`

Consulta `docs/wordpress_api_for_forum.txt` para publicar los datos de la API WordPress en el foro.

## Requisitos

Flutter SDK instalado y un emulador o dispositivo Android disponible.

## Ejecutar

```bash
flutter pub get
flutter run
```

## APK release

```bash
flutter build apk --release
```

El APK se genera en `build/app/outputs/flutter-apk/app-release.apk`.

## Icono

El icono Android usa `assets/images/cesar.png`. Para regenerarlo después de cambiar la foto:

```bash
dart run flutter_launcher_icons
```

La imagen de caja de herramientas está en `assets/images/toolbox.png`.
