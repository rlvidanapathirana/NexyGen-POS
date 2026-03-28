const CACHE='pos-v2';
const OFFLINE_QUEUE_KEY='pos_offline_queue';

self.addEventListener('install',e=>{self.skipWaiting();});
self.addEventListener('activate',e=>{self.clients.claim();});
self.addEventListener('fetch',e=>{
  const url=e.request.url;
  if(url.includes('supabase.co')||url.includes('googleapis')||url.includes('cdn.')||url.includes('fonts.')) return;
  e.respondWith(fetch(e.request).catch(()=>caches.match(e.request)));
});
