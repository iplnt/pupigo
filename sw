const CACHE_NAME = 'pupigo-pwa-v1';
const ASSETS_TO_CACHE = [
  './',
  './index.html',
  './manifest.json',
  'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjQlKZOVRW2I1BFj2F334YxiC4D1T8SiAh-bssx9LoTZ_czxZkexPiwkxfV_xAqieLRDkCr69JxQZH64neOjGMnKlfDkHO76BTzA9t1wjb1SXObC7SQXhz1l-D2evGqpoqXxblERteuLK2vJAMprf9zvSlsy0ZrZ8FmA-bxituGUwlrPbP0fz1aip2NST0E/s192/pupi.png'
];

// 1. Instalación: Guardar archivos base en caché
self.addEventListener('install', (event) => {
  self.skipWaiting();
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(ASSETS_TO_CACHE);
    })
  );
});

// 2. Activación: Limpiar cachés antiguos si actualizas la versión
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cache) => {
          if (cache !== CACHE_NAME) {
            return caches.delete(cache);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

// 3. Estrategia Network-First: Siempre busca datos frescos de internet primero
self.addEventListener('fetch', (event) => {
  if (event.request.method !== 'GET') return;

  event.respondWith(
    fetch(event.request)
      .then((response) => {
        return response;
      })
      .catch(() => {
        return caches.match(event.request);
      })
  );
});
