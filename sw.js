/* ══ BubbleChat Service Worker ══ */
const CACHE_NAME = ‘bubblechat-v1’;

self.addEventListener(‘install’, function(e) {
self.skipWaiting();
});

self.addEventListener(‘activate’, function(e) {
e.waitUntil(clients.claim());
});

/* ══ Réception d’un message depuis le chat ══ */
self.addEventListener(‘message’, function(e) {
if (e.data && e.data.type === ‘NEW_MESSAGE’) {
showNotification(e.data);
}
});

/* ══ Afficher la notification ══ */
function showNotification(data) {
var title   = data.title   || ‘BubbleChat 💬’;
var body    = data.body    || ‘Nouveau message’;
var icon    = data.icon    || ‘/icon-192.png’;
var tag     = data.tag     || ‘bubblechat-msg’;
var url     = data.url     || ‘/chat.html’;

```
var options = {
    body:    body,
    icon:    icon,
    badge:   icon,
    tag:     tag,
    renotify: true,
    vibrate: [200, 100, 200],
    sound:   '/notif.mp3',
    data:    { url: url },
    actions: [
        { action: 'reply',  title: '💬 Répondre' },
        { action: 'close',  title: '✕ Fermer'   }
    ]
};

return self.registration.showNotification(title, options);
```

}

/* ══ Clic sur la notification ══ */
self.addEventListener(‘notificationclick’, function(e) {
e.notification.close();

```
if (e.action === 'close') return;

var url = (e.notification.data && e.notification.data.url) ? e.notification.data.url : '/chat.html';

e.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then(function(list) {
        for (var i = 0; i < list.length; i++) {
            var client = list[i];
            if (client.url.indexOf('chat.html') !== -1 && 'focus' in client) {
                return client.focus();
            }
        }
        if (clients.openWindow) {
            return clients.openWindow(url);
        }
    })
);
```

});
