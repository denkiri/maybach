'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.json": "b76dc7053475cc2f9ab2be983213d7d5",
"assets/AssetManifest.bin": "b96368590555c3bb3db2389d05bfe1e4",
"assets/assets/images/welcome_bonus_banner.png": "8bf003e2c63a0dc3521ef40a5849895f",
"assets/assets/images/maybach_banner_2.png": "a89fea060d411838ae31373baf908df3",
"assets/assets/images/maybach_logo.svg": "40ea1e7e95953700d53ad75bab0e4582",
"assets/assets/images/cash_back_banner.png": "1a78efe86aa7873a97ce7b07f1c572e5",
"assets/assets/images/cash_back_bonus_banner.png": "b970f40ddf50f11e6f7df4fc7851db2d",
"assets/assets/images/maybach_logo.png": "4cfd1892e76dc8ab02310ff2b1eedf71",
"assets/assets/images/platinum_banner.png": "24fc614cbccaa0924fbcdab6003cfd20",
"assets/assets/images/cloudworkers_banner.png": "1d21df3f365372eac5b462b1e2ec82c9",
"assets/assets/images/remotasks_banner.png": "a3da69193fdbb2562bfc4d6e0a1932b8",
"assets/assets/images/gold_banner.png": "040b2e3f2374eb06342c381966333a64",
"assets/assets/images/pro_bonus_banner.png": "3ee6d3a93dddaa0da6b1c30042685842",
"assets/assets/images/certification_banner.png": "0ccdd414edff8ea35d5a461da632be39",
"assets/assets/images/maybach.png": "5a2b252bcc7e46f6f558d5a210d6e0ce",
"assets/assets/images/advertising_agent_banner.png": "dcd1e5324f183e0cb7ae0ee77782c33a",
"assets/assets/images/silver_banner.png": "3aed291f8ca29f64119ba77758e33963",
"assets/assets/images/maybach_banner.png": "f61eb57131a5771c8212048ba3badbe3",
"assets/assets/images/membership_banner.png": "962c3cafaaf87216617d6ba43c04a6c8",
"assets/assets/images/whatsup_banner.png": "c433ce298ef5d9c1e5c4dae987d800d5",
"assets/assets/images/verification_banner.png": "903c6982c1f43b210e1a2f77987ca829",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"assets/fonts/MaterialIcons-Regular.otf": "5816cc1ecd5b9cdf8d70e00991f9955b",
"assets/AssetManifest.bin.json": "bf3c7a59b416f4890064b63ff654f402",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/NOTICES": "f9763ba36e194e150a3fa0a3730e9a71",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "00a0d5a58ed34a52b40eb372392a8b98",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "eb2fe7fc364313c08e903eafc381e0b6",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "0bfcc89b0c7c8c43c458ee6ad9277c3f",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"manifest.json": "182060ee31431ae95feefde5c7d1ff7b",
"version.json": "b15ede7573cd8a8c47d8d1d14586050a",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"index.html": "1984dac52226b6acd87ac15cde8e4854",
"/": "1984dac52226b6acd87ac15cde8e4854",
"flutter_bootstrap.js": "25e6b469f74cc69b9796216fdbac5eb9",
"icons/site.webmanifest": "053100cb84a50d2ae7f5492f7dd7f25e",
"icons/favicon.ico": "9061ccd0fa5abe0a3dc9920757b19789",
"icons/android-chrome-512x512.png": "a73df24b281e54edb3d8071e442f97ee",
"icons/favicon-32x32.png": "2a5702a6d812de2c9fb8b0772dbe2fbc",
"icons/apple-touch-icon.png": "bd7530c365b03c5f0e7427cf377b11b6",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/favicon-16x16.png": "f16fcedd790ccde3a9fa8829515284db",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/android-chrome-192x192.png": "0fdac2bafc7bd8f41a850aad0de280c0",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"main.dart.js": "147c8c73ff379394a4ec7899a5e5cced"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
