export 'twitter_embed_stub.dart'
    if (dart.library.html) 'twitter_embed_web.dart'
    if (dart.library.js_interop) 'twitter_embed_web.dart';
