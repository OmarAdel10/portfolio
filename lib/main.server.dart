/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

import 'package:jaspr/dom.dart';
// Server-specific Jaspr import.
import 'package:jaspr/server.dart';

// Imports the [App] component.
import 'app.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

/// Production origin used for canonical links, sitemap and Open Graph — swap to
/// your real domain after attaching it in Cloudflare Pages.
const String productionUrl = 'https://omaradel.pages.dev';

/// Applies the saved theme before first paint so the site never flashes from
/// light to dark. The default (no saved value) is the light PostHog theme.
const String _themeInitJs =
    "(function(){try{var t=localStorage.getItem('portfolio-theme');"
    "if(t==='dark'){document.documentElement.setAttribute('data-theme','dark');}}catch(e){}})();";

/// Critical CSS to prevent FOUC - hides .reveal and .intro-item elements
/// before any scripts execute. Must be inlined FIRST in <head>.
const String _criticalCss = '''
  .intro-hold .reveal,
  .intro-hold .intro-item {
    opacity: 0 !important;
    transform: translateY(22px) !important;
  }
  .intro-hold .cursor-dot,
  .intro-hold .cursor-ring {
    opacity: 0 !important;
  }
''';

/// Marks JS as enabled, reveals `.reveal` elements, and handles email fallback.
/// Direct click handlers on all `.email-fallback` links:
/// tries mailto, then after 1.5s if page still has focus -> Gmail compose.
/// Adds the intro hold class before first paint (unless reduced motion).
/// Hero removes it when the intro finishes; failsafe removes it after 9s.
const String _introHoldJs =
    "(function(){try{"
    "if(window.matchMedia&&window.matchMedia('(prefers-reduced-motion: reduce)').matches)return;"
    "document.documentElement.classList.add('intro-hold');"
    "setTimeout(function(){document.documentElement.classList.remove('intro-hold');},9000);"
    "}catch(e){}})();";

const String _motionJs = """
(function(){
  var d=document.documentElement;
  d.classList.add('js-enabled');
  var reduce=window.matchMedia&&window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  function revealVisible(){
    var sheet='opacity .65s cubic-bezier(0.22,0.61,0.36,1), transform .65s cubic-bezier(0.22,0.61,0.36,1)';
    var els=[].slice.call(document.querySelectorAll('.reveal'));
    var vh=window.innerHeight||document.documentElement.clientHeight;
    for(var i=0;i<els.length;i++){
      var el=els[i];
      // Skip only elements that already carry the revealed inline state.
      // Hydration can wipe style attributes (DomRenderElement.update()), so
      // bookkeeping by element identity poisons itself — re-check current
      // style instead, so wiped elements get re-revealed on the next pass.
      if(el.style.opacity==='1') continue;
      // Once the pinned scrub is active it owns the reveal of the panel, so
      // these elements must NOT get inline styles (they would beat the CSS
      // custom properties that drive the scrub). Before the hero intro
      // finishes (!heroReady) the panel stays hidden via the CSS defaults so
      // it only appears on scroll; once the scene deactivates it reverts to
      // the normal reveal-on-scroll path.
      if(el.closest('.scene-stage') && (sceneActive || !heroReady)) continue;
      var r=el.getBoundingClientRect();
      if(r.top<vh){
        if(reduce){
          // Reduced motion: reveal immediately without animation
          el.style.opacity='1';
          el.style.transform='translateY(0)';
        }else{
          el.style.transition=sheet;
          // Staggered one-by-one reveal: cards carry data-stagger-index and
          // fade in with an increasing delay so they pop in sequentially.
          var st=el.getAttribute('data-stagger-index');
          if(st!==null){el.style.transitionDelay=(parseInt(st,10)*160)+'ms';}
          el.style.opacity='1'; el.style.transform='translateY(0)';
        }
      }
    }
  }
  // The scroll listener and the rAF scheduler live in the scene block below,
  // so there is exactly one of each for the whole page.

  // ---- Scroll-scrubbed hero -> Expertise scene ---------------------------
  // After the hero intro finishes (.phase-done), the .scene wrapper (400vh)
  // holds a sticky .scene-stage (left = hero, right = expertise). Scroll
  // drives progress p (0..1); JS writes CSS custom properties and CSS applies
  // the hero shift, expertise title and cards. Fully reversible on scroll up.
  // No scroll-lock, no preventDefault — scrolling is never hijacked.
  var sceneActive = false;
  var heroReady = false;
  var geometryReady = false;
  var wrapperTop = 0, wrapperHeight = 0, vh = 0, heroShiftMax = 0;
  var heroInner = null, titleEl = null, cards = [];

  function easeOutCubic(x){ return 1 - Math.pow(1 - x, 3); }
  function clamp01(x){ return x < 0 ? 0 : (x > 1 ? 1 : x); }
  function getScene(){ return document.querySelector('.scene'); }
  function getStage(){ return document.querySelector('.scene-stage'); }
  function measureScene(){
    var s = getScene();
    if(!s) return;
    var r = s.getBoundingClientRect();
    wrapperTop = r.top + window.pageYOffset;
    wrapperHeight = s.offsetHeight || r.height;
    vh = window.innerHeight || d.clientHeight;
    // The stage sticks right below the floating header pill.
    var header = document.querySelector('.site-header');
    var headerH = header ? Math.round(header.getBoundingClientRect().height) : 64;
    d.style.setProperty('--scene-top', headerH + 'px');
  }
  // How far the hero may travel left before the hero column would clip it.
  // Measured on the untransformed element, never per frame.
  function measureHeroShift(){
    heroShiftMax = 0;
    if(!heroInner) return;
    var hero = heroInner.closest('.hero');
    if(!hero) return;
    var prev = heroInner.style.transform;
    heroInner.style.transform = 'none';
    var hr = heroInner.getBoundingClientRect();
    var herr = hero.getBoundingClientRect();
    var hcs = window.getComputedStyle(hero);
    heroInner.style.transform = prev;
    var heroLeft = herr.left + (parseFloat(hcs.paddingLeft) || 0);
    heroShiftMax = Math.max(0, hr.left - heroLeft);
  }
  // Strip any inline reveal state from the panel so the scrub owns it.
  function resetSceneEls(){
    var owned = [].slice.call(document.querySelectorAll('.scene-stage .reveal'));
    owned.forEach(function(el){
      el.style.opacity='';
      el.style.transform='';
      el.style.transition='';
      el.style.transitionDelay='';
      el.style.removeProperty('--reveal');
      el.style.removeProperty('--card-blur');
      el.classList.remove('lit');
    });
  }
  function initSceneEls(){
    heroInner = document.querySelector('.hero-inner');
    titleEl = document.querySelector('.expertise .section-head');
    cards = [].slice.call(document.querySelectorAll('.skill-card.reveal'));
    cards.forEach(function(c){ c._done = false; });
    resetSceneEls();
    measureHeroShift();
  }
  function tickCard(card, local){
    if(local >= 1 && !card._done){
      card._done = true;
      card.classList.add('lit');
      setTimeout(function(){ card.classList.remove('lit'); }, 800);
    }
    if(local < 1){ card._done = false; card.classList.remove('lit'); }
  }
  function applyScene(p){
    // Hero glides left (p 0.00 -> 0.30), existing shift look.
    var h = easeOutCubic(clamp01(p / 0.30));
    if(heroInner) heroInner.style.setProperty('--hero-shift', (heroShiftMax * h).toFixed(2) + 'px');
    if(p > 0.01) d.classList.add('hero-shifted'); else d.classList.remove('hero-shifted');
    // Expertise title (p 0.25 -> 0.40).
    var t = easeOutCubic(clamp01((p - 0.25) / 0.15));
    if(titleEl) titleEl.style.setProperty('--reveal', t);
    // Cards, staggered with overlapping ranges.
    var vals = [
      easeOutCubic(clamp01((p - 0.40) / 0.20)),
      easeOutCubic(clamp01((p - 0.55) / 0.20)),
      easeOutCubic(clamp01((p - 0.70) / 0.20))
    ];
    for(var i=0;i<cards.length;i++){
      var card = cards[i];
      if(!card) continue;
      var r = vals[i] !== undefined ? vals[i] : 0;
      card.style.setProperty('--reveal', r);
      // Depth blur: a revealed card picks up a little blur as the cards below
      // it come in, so the stack reads as depth instead of a flat list.
      var blur = 8 * (1 - r);
      for(var j=i+1;j<cards.length;j++){
        blur += 0.8 * (vals[j] !== undefined ? vals[j] : 0);
      }
      card.style.setProperty('--card-blur', blur.toFixed(2) + 'px');
      tickCard(card, r);
    }
  }

  var ticking = false;
  function sceneTick(){
    if(!geometryReady){ measureScene(); geometryReady = true; }
    var scrollY = window.pageYOffset || d.scrollTop;
    if(sceneActive){
      var span = wrapperHeight - vh;
      if(span > 0){
        var p = clamp01((scrollY - wrapperTop) / span);
        applyScene(p);
      }
    }
    revealVisible();
    ticking = false;
  }
  function request(){ if(!ticking){ ticking = true; requestAnimationFrame(sceneTick); } }

  function applyNoScene(){
    // The pinned scene needs room for the hero and the three cards side by
    // side: below 900px wide (or 700px tall) the page falls back to the
    // normal stacked document.
    var noScene = reduce
      || (window.innerWidth || d.clientWidth) < 900
      || (window.innerHeight || d.clientHeight) < 700;
    d.classList.toggle('no-scene', noScene);
    var wantActive = !noScene && heroReady;
    if(wantActive !== sceneActive){
      sceneActive = wantActive;
      var st = getStage();
      if(st){
        if(wantActive){ st.classList.add('scrubbed'); initSceneEls(); }
        else { st.classList.remove('scrubbed'); d.classList.remove('hero-shifted'); resetSceneEls(); }
      }
      geometryReady = false;
    }
    measureScene();
  }

  // Initial layout class + first reveal pass.
  applyNoScene();
  revealVisible();

  // Wait for the hero intro to finish (.phase-done), then activate the scrub.
  function pollHero(){
    if(!heroReady && document.querySelector('.hero.phase-done')){
      heroReady = true;
      applyNoScene();
      request();
    }
  }
  pollHero();
  var heroPoll = setInterval(pollHero, 100);
  setTimeout(function(){ clearInterval(heroPoll); }, 20000);

  window.addEventListener('scroll', request, {passive: true});
  window.addEventListener('resize', function(){ geometryReady = false; measureScene(); measureHeroShift(); applyNoScene(); request(); });
  // Deep links / header nav link to '#expertise' resolve inside the pinned scene
  // where the panel is hidden until p > 0.25: scroll to the end of the scene so
  // the panel arrives fully revealed. Falls back to native scroll if the scene
  // is not yet active (e.g. clicked right after load).
  document.addEventListener('click', function(e){
    var a = e.target && e.target.closest ? e.target.closest('a[href="#expertise"]') : null;
    if(!a || !sceneActive) return;
    var s = getScene();
    if(s){
      e.preventDefault();
      var endY = (s.getBoundingClientRect().top + window.pageYOffset)
        + Math.max(0, s.offsetHeight - (window.innerHeight || d.clientHeight));
      window.scrollTo(0, Math.round(endY));
    }
  });
  new MutationObserver(request).observe(d, {childList: true, subtree: true});
  request();

  // ---- Email fallback (mailto -> Gmail) ----
  var EMAIL = 'omaradel1.dev@gmail.com';
  var SUBJ = 'Project inquiry – portfolio';
  var BODY = 'Hi Omar,\\n\\nI came across your portfolio and would like to discuss a potential project.\\n\\n';
  var MAILTO = 'mailto:' + EMAIL + '?subject=' + encodeURIComponent(SUBJ) + '&body=' + encodeURIComponent(BODY);
  var GMAIL = 'https://mail.google.com/mail/?view=cm&fs=1&to=' + encodeURIComponent(EMAIL) + '&su=' + encodeURIComponent(SUBJ) + '&body=' + encodeURIComponent(BODY);
  
  function attachEmailFallback(){
    var links = document.querySelectorAll('.email-fallback');
    for(var i=0;i<links.length;i++){
      var link = links[i];
      if(link._fallbackAttached) continue;
      link._fallbackAttached = true;
      link.addEventListener('click', function(e){
        e.preventDefault();
        window.location.href = MAILTO;
        setTimeout(function(){
          if(document.hasFocus()){
            window.open(GMAIL, '_blank', 'noopener,noreferrer');
          }
        }, 1500);
      });
    }
  }
  attachEmailFallback();
  // Re-attach on DOM changes (hydration)
  new MutationObserver(attachEmailFallback).observe(d,{childList:true,subtree:true});
})();
""";

/// Interactive dot-matrix background on a fixed canvas (reacts to the cursor)
/// plus a custom animated cursor (dot + trailing ring) that grows over links.
/// Both are disabled on touch/coarse pointers and under reduced motion.
const String _bgJs = """
(function(){
  function boot(){
  var d=document.documentElement;
  function reduced(){ return window.matchMedia&&window.matchMedia('(prefers-reduced-motion: reduce)').matches; }
  function coarse(){ return window.matchMedia&&window.matchMedia('(pointer: coarse)').matches; }

  // ---- Custom cursor ----
  var dot=document.querySelector('.cursor-dot');
  var ring=document.querySelector('.cursor-ring');
  var usable=dot&&ring&&!reduced()&&!coarse()&&('PointerEvent' in window||'onmousemove' in window);
  if(usable){ d.classList.add('has-custom-cursor'); }

  var cv=document.getElementById('bg-canvas');
  if(!cv&&document.body){ cv=document.createElement('canvas'); cv.id='bg-canvas'; cv.className='bg-canvas'; cv.setAttribute('aria-hidden','true'); document.body.insertBefore(cv,document.body.firstChild); }
  if(!cv||!cv.getContext||reduced()) return;
  var ctx=cv.getContext('2d');
  var touch=coarse();
  var dpr=getCappedDpr();
  ctx.scale(dpr, dpr);

  var SP=touch?42:28, W=0, H=0, dots=[], mouse={x:-99999,y:-99999};
  var INK='#23251d';
  function refreshColors(){ var cs=getComputedStyle(d); INK=cs.getPropertyValue('--ink').trim()||INK; }
  refreshColors();
  new MutationObserver(refreshColors).observe(d,{attributes:true,attributeFilter:['data-theme']});

  function hexToRgb(h){ h=h.replace('#',''); if(h.length===3){ h=h.charAt(0)+h.charAt(0)+h.charAt(1)+h.charAt(1)+h.charAt(2)+h.charAt(2); } var n=parseInt(h,16); return [(n>>16)&255,(n>>8)&255,n&255]; }
  function rgba(hex,a){ var r=hexToRgb(hex); return 'rgba('+r[0]+','+r[1]+','+r[2]+','+a+')'; }
  function getCappedDpr(){ return Math.min(window.devicePixelRatio||1, 1.5); }

  function size(){ var dpr=getCappedDpr(); W=cv.width=window.innerWidth*dpr; H=cv.height=window.innerHeight*dpr; cv.style.width=window.innerWidth+"px"; cv.style.height=window.innerHeight+"px"; ctx.scale(dpr, dpr); build(); }
  function build(){ dots=[]; var ix=Math.floor(W/SP), iy=Math.floor(H/SP);
    for(var i=0;i<ix;i++)for(var j=0;j<iy;j++)
      dots.push({x:i*SP+SP/2+(Math.random()-0.5)*5, y:j*SP+SP/2+(Math.random()-0.5)*5, ph:Math.random()*6.2832});
  }
  window.addEventListener('resize',size);
  window.addEventListener('mousemove',function(e){mouse.x=e.clientX;mouse.y=e.clientY;},{passive:true});
  window.addEventListener('mouseout',function(e){ if(!e.relatedTarget){mouse.x=-99999;mouse.y=-99999;} });
  size();

  function drawFrame(t){
    if(t===undefined){t=performance.now();}
    ctx.clearRect(0,0,W,H);
    var RD=140, time=t;
    for(var i=0;i<dots.length;i++){ var p=dots[i];
      p.x+=Math.sin(time*0.00012+p.ph)*0.02;
      p.y+=Math.cos(time*0.00017+p.ph)*0.02;
      var dx=p.x-mouse.x, dy=p.y-mouse.y;
      var dist=Math.sqrt(dx*dx+dy*dy);
      var n=Math.max(0,1-dist/RD);
      var a=0.10+n*0.55;
      var s=1+n*3.2;
      ctx.beginPath(); ctx.arc(p.x,p.y,s,0,6.2832); ctx.fillStyle=rgba(INK,Math.min(1,a)); ctx.fill();
    }
    requestAnimationFrame(drawFrame);
  }
  drawFrame();

  // ---- Cursor motion (dot snaps, ring eases behind) ----
  if(usable){
    var mx=-100,my=-100,rx=-100,ry=-100,shown=false;
    document.addEventListener('mousemove',function(e){ mx=e.clientX; my=e.clientY; if(!shown){shown=true;dot.style.opacity='1';ring.style.opacity='1';} },{passive:true});
    (function loop(){ rx+=(mx-rx)*0.18; ry+=(my-ry)*0.18;
      dot.style.transform='translate('+(mx-4)+'px,'+(my-4)+'px)';
      ring.style.transform='translate('+(rx-17)+'px,'+(ry-17)+'px)';
      requestAnimationFrame(loop);
    })();
    document.addEventListener('mouseover',function(e){ var t=e.target; if(t&&t.closest&&t.closest('a,button,.card,input,textarea')) ring.classList.add('is-hover'); });
    document.addEventListener('mouseout',function(e){ var t=e.target; if(t&&t.closest&&t.closest('a,button,.card,input,textarea')) ring.classList.remove('is-hover'); });
  }
  }
  if(document.readyState==='loading'){window.addEventListener('DOMContentLoaded',boot);}else{boot();}
})();
""";

/// Structured-data Person markup for search engines.
const String _jsonLd =
    '{"@context":"https://schema.org","@type":"Person",'
    '"name":"Omar Adel","url":"https://omaradel.dev",'
    '"image":"https://omaradel.dev/images/avatar.jpg",'
    '"jobTitle":"Software Engineer",'
    '"email":"mailto:omaradel1.dev@gmail.com",'
    '"sameAs":["https://github.com/OmarAdel10","https://www.linkedin.com/in/omaradel10"]}';

/// Open Graph metas. The [Document.meta] map renders `name` attributes,
/// which the OGP spec (and strict crawlers such as LinkedIn) reject — these
/// are emitted from [head] as `property` meta elements instead.
const Map<String, String> _ogMeta = {
  'og:title': 'Omar Adel — Software Engineer & App Developer',
  'og:description': 'Cross-platform apps with Flutter and C# .NET, edge-backend services, and practical AI tooling.',
  'og:type': 'website',
  'og:url': productionUrl,
  'og:image': '$productionUrl/images/og-image.jpg',
  'og:image:width': '1200',
  'og:image:height': '630',
  'og:image:alt': 'Omar Adel — Software Engineer (portrait)',
  'og:image:type': 'image/jpeg',
  'og:site_name': 'Omar Adel — Portfolio',
  'og:locale': 'en_US',
};

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(
    options: defaultServerOptions,
  );

  // Starts the app.
  runApp(
    Document(
      title: 'Omar Adel — Software Engineer & App Developer',
      lang: 'en',
      meta: {
        'description':
            'Personal portfolio of Omar Adel, a software engineer building cross-platform apps with Flutter and C# .NET, edge-backend services, and practical AI tooling.',
        'theme-color': '#eeefe9',
        'keywords': 'Omar Adel, software engineer, Flutter, C# .NET, app developer, portfolio',
        'author': 'Omar Adel',
        'google-site-verification': 'Uzi0q0Piapes6QUGWVdSwhoOjirhtK-YkBMguFXrhPA',
        'twitter:card': 'summary_large_image',
        'twitter:title': 'Omar Adel — Software Engineer & App Developer',
        'twitter:description':
            'Cross-platform apps with Flutter and C# .NET, edge-backend services, and practical AI tooling.',
        'twitter:image': '$productionUrl/images/og-image.jpg',
        'twitter:image:alt': 'Omar Adel — Software Engineer (portrait)',
      },
      head: [
        // Critical CSS - MUST be first to prevent FOUC (flash of unstyled content)
        .element(
          tag: 'style',
          children: [.text(_criticalCss)],
        ),
        script(content: _themeInitJs),
        script(content: _introHoldJs),
        script(content: _motionJs),
        script(content: _bgJs),
        // Open Graph metas must carry `property` attributes (OGP spec); the
        // `meta` map above emits `name`, so they are rendered here instead.
        for (final entry in _ogMeta.entries) meta(attributes: {'property': entry.key, 'content': entry.value}),
        link(
          rel: 'icon',
          href: '/favicon.ico',
          attributes: {'sizes': 'any'},
        ),
        link(
          rel: 'icon',
          href: '/images/favicon-32x32.png',
          attributes: {'type': 'image/png', 'sizes': '32x32'},
        ),
        link(
          rel: 'apple-touch-icon',
          href: '/images/apple-touch-icon.png',
          attributes: {'sizes': '180x180'},
        ),
        link(
          rel: 'manifest',
          href: '/site.webmanifest',
        ),
        link(
          href: productionUrl,
          attributes: {'rel': 'canonical'},
        ),
        script(attributes: {'type': 'application/ld+json'}, content: _jsonLd),
      ],
      body: div(classes: 'app-shell', [
        div(classes: 'cursor-dot', []),
        div(classes: 'cursor-ring', []),
        const App(),
      ]),
    ),
  );
}
