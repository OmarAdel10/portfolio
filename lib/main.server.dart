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
const String productionUrl = 'https://omaradel.dev';

/// Applies the saved theme before first paint so the site never flashes from
/// light to dark. The default (no saved value) is the light PostHog theme.
const String _themeInitJs =
    "(function(){try{var t=localStorage.getItem('portfolio-theme');"
    "if(t==='dark'){document.documentElement.setAttribute('data-theme','dark');}}catch(e){}})();";

/// Marks JS as enabled, reveals `.reveal` elements, and handles email fallback.
/// Direct click handlers on all `.email-fallback` links:
/// tries mailto, then after 1.5s if page still has focus -> Gmail compose.
const String _motionJs = """
(function(){
  var d=document.documentElement;
  d.classList.add('js-enabled');
  if(window.matchMedia&&window.matchMedia('(prefers-reduced-motion: reduce)').matches)return;
  var revealed=[],ticking=false;
  function revealVisible(){
    var sheet='opacity .65s cubic-bezier(0.22,0.61,0.36,1), transform .65s cubic-bezier(0.22,0.61,0.36,1)';
    var els=[].slice.call(document.querySelectorAll('.reveal'));
    var vh=window.innerHeight||document.documentElement.clientHeight;
    for(var i=0;i<els.length;i++){
      var el=els[i]; if(revealed.indexOf(el)>=0)continue;
      var r=el.getBoundingClientRect();
      if(r.top<vh){ el.style.transition=sheet; el.style.opacity='1'; el.style.transform='translateY(0)'; revealed.push(el); }
    }
  }
  function request(){ if(!ticking){ ticking=true; requestAnimationFrame(function(){ ticking=false; revealVisible(); }); } }
  window.addEventListener('scroll',request,{passive:true});
  window.addEventListener('resize',request);
  var mut=new MutationObserver(request); mut.observe(d,{childList:true,subtree:true});
  revealVisible(); setTimeout(revealVisible,500); setTimeout(revealVisible,1600);

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

  var SP=touch?42:28, W=0, H=0, dots=[], mouse={x:-99999,y:-99999};
  var INK='#23251d';
  function refreshColors(){ var cs=getComputedStyle(d); INK=cs.getPropertyValue('--ink').trim()||INK; }
  refreshColors();
  new MutationObserver(refreshColors).observe(d,{attributes:true,attributeFilter:['data-theme']});

  function hexToRgb(h){ h=h.replace('#',''); if(h.length===3){ h=h.charAt(0)+h.charAt(0)+h.charAt(1)+h.charAt(1)+h.charAt(2)+h.charAt(2); } var n=parseInt(h,16); return [(n>>16)&255,(n>>8)&255,n&255]; }
  function rgba(hex,a){ var r=hexToRgb(hex); return 'rgba('+r[0]+','+r[1]+','+r[2]+','+a+')'; }

  function size(){ W=cv.width=window.innerWidth; H=cv.height=window.innerHeight; build(); }
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
    if(!touch) requestAnimationFrame(drawFrame);
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
const String _jsonLd = '{"@context":"https://schema.org","@type":"Person",'
    '"name":"Omar Adel","url":"https://omaradel.dev",'
    '"image":"https://omaradel.dev/images/avatar.png",'
    '"jobTitle":"Software Engineer",'
    '"email":"mailto:omaradel1.dev@gmail.com",'
    '"sameAs":["https://github.com/OmarAdel10","https://www.linkedin.com/in/omaradel10"]}';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(
    options: defaultServerOptions,
  );

  // Starts the app.
  runApp(Document(
    title: 'Omar Adel — Software Engineer & App Developer',
    lang: 'en',
    meta: {
      'description':
          'Personal portfolio of Omar Adel, a software engineer building cross-platform apps with Flutter and C# .NET, edge-backend services, and practical AI tooling.',
      'theme-color': '#eeefe9',
      'keywords': 'Omar Adel, software engineer, Flutter, C# .NET, app developer, portfolio',
      'author': 'Omar Adel',
      'og:title': 'Omar Adel — Software Engineer & App Developer',
      'og:description':
          'Cross-platform apps with Flutter and C# .NET, edge-backend services, and practical AI tooling.',
      'og:type': 'website',
      'og:url': productionUrl,
      'og:image': '$productionUrl/images/avatar.png',
      'twitter:card': 'summary',
      'twitter:title': 'Omar Adel — Software Engineer & App Developer',
      'twitter:description':
          'Cross-platform apps with Flutter and C# .NET, edge-backend services, and practical AI tooling.',
      'twitter:image': '$productionUrl/images/avatar.png',
    },
    head: [
      script(content: _themeInitJs),
      script(content: _motionJs),
      script(content: _bgJs),
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
  ));
}