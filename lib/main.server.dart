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
/// before any scripts execute. Must be inlined FIRST in the `head`.
const String _criticalCss = '''
  .intro-hold .reveal,
  .intro-hold .intro-item {
    opacity: 0 !important;
    transform: translateY(12px) !important;
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
  // Keep the MediaQueryList around: if the visitor changes their OS motion
  // preference while the page is open, the pinned scrub has to follow —
  // otherwise it keeps running for someone who just asked it to stop.
  var reduceMQ=window.matchMedia?window.matchMedia('(prefers-reduced-motion: reduce)'):null;
  var reduce=!!(reduceMQ&&reduceMQ.matches);
  function revealVisible(){
    var sheet='opacity var(--dur-panel) var(--ease-out), transform var(--dur-panel) var(--ease-out)';
    var els=[].slice.call(document.querySelectorAll('.reveal'));
    var vh=window.innerHeight||document.documentElement.clientHeight;
    for(var i=0;i<els.length;i++){
      var el=els[i];
      // Skip only elements that already carry the revealed inline state.
      // Hydration can wipe style attributes (DomRenderElement.update()), so
      // bookkeeping by element identity poisons itself — re-check current
      // style instead, so wiped elements get re-revealed on the next pass.
      if(el.style.opacity==='1') continue;
      // The pinned scrub owns the panel: inline styles would beat the CSS
      // custom properties that drive the recede and the reveals.
      if(el.closest('.scene-stage') && sceneActive) continue;
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
        // Marks the head so its hairline rule can draw across.
        el.classList.add('in');
      }
    }
  }
  // The scroll listener and the rAF scheduler live in the scene block below,
  // so there is exactly one of each for the whole page.

  // ---- Scroll-scrubbed hero -> Expertise scene ---------------------------
  // The .scene wrapper is 400vh tall and holds a sticky .scene-stage with the
  // hero and the expertise panel layered inside it. Scroll drives progress
  // p (0..1); JS writes CSS custom properties and CSS applies the hero
  // recede and the panel reveals. Fully reversible on scroll up. No
  // scroll-lock and no preventDefault: scrolling is never hijacked.
  var sceneActive = false;
  var geometryReady = false;
  var wrapperTop = 0, wrapperHeight = 0, vh = 0;
  var heroInner = null, headEl = null, subEl = null, cols = [];

  function easeOutCubic(x){ return 1 - Math.pow(1 - x, 3); }
  function easeInOutCubic(x){
    return x < 0.5 ? 4 * x * x * x : 1 - Math.pow(-2 * x + 2, 3) / 2;
  }
  function clamp01(x){ return x < 0 ? 0 : (x > 1 ? 1 : x); }
  function getScene(){ return document.querySelector('.scene'); }
  function getStage(){ return document.querySelector('.scene-stage'); }
  function measureScene(){
    var s = getScene();
    if(!s) return false;
    var r = s.getBoundingClientRect();
    wrapperTop = r.top + window.pageYOffset;
    wrapperHeight = s.offsetHeight || r.height;
    vh = window.innerHeight || d.clientHeight;
    // The stage sticks right below the floating header pill.
    var header = document.querySelector('.site-header');
    var headerH = header ? Math.round(header.getBoundingClientRect().height) : 64;
    d.style.setProperty('--scene-top', headerH + 'px');
    return true;
  }
  // Strip any inline reveal state from the panel so the scrub owns it.
  function resetSceneEls(){
    var owned = [].slice.call(document.querySelectorAll('.scene-stage .reveal'));
    owned.forEach(function(el){
      el.style.opacity='';
      el.style.transform='';
      el.style.transition='';
      el.style.transitionDelay='';
      el.style.removeProperty('--head-reveal');
      el.style.removeProperty('--sub-reveal');
      el.style.removeProperty('--col-reveal');
      el.style.removeProperty('--col-blur');
      el.classList.remove('in');
    });
    // The subtitle carries the scrub's --sub-reveal but is not a .reveal
    // element, so the sweep above never reaches it. Clear it explicitly,
    // or the panel keeps its last scrub state after the scene switches off.
    if(subEl) subEl.style.removeProperty('--sub-reveal');
    // The hero must go back to its resting state when the scene switches off.
    if(heroInner){
      heroInner.style.removeProperty('--hero-opacity');
      heroInner.style.removeProperty('--hero-transform');
      heroInner.style.removeProperty('--hero-filter');
      heroInner.style.removeProperty('--hero-pointer-events');
    }
    d.classList.remove('scrubbing');
  }
  function initSceneEls(){
    heroInner = document.querySelector('.hero .hero-inner');
    headEl = document.querySelector('.expertise .section-head');
    subEl = document.querySelector('.expertise .section-subtitle');
    cols = [].slice.call(document.querySelectorAll('.expertise .skill-card'));
    resetSceneEls();
  }
  function applyScene(p){
    // Hero recedes in place (p 0.00 -> 0.28): scale 1 -> 0.95, lift 0 -> -6px,
    // blur 0 -> 2.5px. It then fades out (p 0.18 -> 0.34).
    var recede = easeInOutCubic(clamp01(p / 0.28));
    var fade = easeInOutCubic(clamp01((p - 0.18) / 0.16));
    var moving = recede > 0.0005;
    if(heroInner){
      heroInner.style.setProperty('--hero-opacity', (1 - fade).toFixed(3));
      // The transform and the filter are left unset at rest so the hero
      // renders exactly as it would without the scene.
      heroInner.style.setProperty('--hero-transform', moving
        ? 'translateY(' + (-6 * recede).toFixed(2) + 'px) scale(' + (1 - 0.05 * recede).toFixed(4) + ')'
        : 'none');
      heroInner.style.setProperty('--hero-filter', moving
        ? 'blur(' + (2.5 * recede).toFixed(2) + 'px)'
        : 'none');
      // A faded-out hero must not keep swallowing clicks meant for the panel.
      heroInner.style.setProperty('--hero-pointer-events', fade > 0.98 ? 'none' : 'auto');
    }
    d.classList.toggle('scrubbing', moving);
    // Expertise head (p 0.30 -> 0.46); the subtitle trails it by 0.04.
    var head = easeOutCubic(clamp01((p - 0.30) / 0.16));
    var sub = easeOutCubic(clamp01((p - 0.34) / 0.16));
    if(headEl) headEl.style.setProperty('--head-reveal', head.toFixed(3));
    if(subEl) subEl.style.setProperty('--sub-reveal', sub.toFixed(3));
    // Columns: 0.44 -> 0.66, 0.52 -> 0.74, 0.60 -> 0.82.
    var vals = [];
    for(var i=0;i<cols.length;i++){
      vals.push(easeOutCubic(clamp01((p - (0.44 + i * 0.08)) / 0.22)));
    }
    for(var k=0;k<cols.length;k++){
      var el = cols[k];
      if(!el) continue;
      var r = vals[k];
      el.style.setProperty('--col-reveal', r.toFixed(3));
      // Rack focus: a column stays soft until it arrives, and the columns
      // that have not arrived yet stay soft too. Everything settles crisp.
      var blur = 1.2 * (1 - r);
      for(var j=k+1;j<vals.length;j++){ blur += 1.2 * (1 - vals[j]); }
      if(blur > 2.4) blur = 2.4;
      el.style.setProperty('--col-blur', blur.toFixed(2) + 'px');
    }
  }

  var ticking = false;
  function sceneTick(){
    if(!geometryReady){ geometryReady = measureScene(); }
    var scrollY = window.pageYOffset || d.scrollTop;
    if(sceneActive && geometryReady){
      var span = wrapperHeight - vh;
      if(span > 0){
        applyScene(clamp01((scrollY - wrapperTop) / span));
      }
    }
    revealVisible();
    applySectionCrossfade();
    ticking = false;
  }
  function request(){ if(!ticking){ ticking = true; requestAnimationFrame(sceneTick); } }

  function applyNoScene(){
    // The pinned scene runs at all widths so the hero scroll animation works
    // on mobile viewports too. It is only disabled under prefers-reduced-motion.
    var noScene = reduce;
    d.classList.toggle('no-scene', noScene);
    var wantActive = !noScene;
    if(wantActive !== sceneActive){
      sceneActive = wantActive;
      if(getStage()){
        if(wantActive){ initSceneEls(); }
        else { resetSceneEls(); }
      }
      geometryReady = false;
    }
    measureScene();
  }

  // Initial layout class + first reveal pass.
  applyNoScene();
  revealVisible();

  // The document-space y at the end of the scene, where the expertise panel
  // is fully revealed and the pin releases.
  function sceneEndY(){
    var s = getScene();
    if(!s) return null;
    return Math.round((s.getBoundingClientRect().top + window.pageYOffset)
      + Math.max(0, s.offsetHeight - (window.innerHeight || d.clientHeight)));
  }
  function jumpToExpertise(){
    var y = sceneEndY();
    if(y === null) return false;
    window.scrollTo(0, y);
    return true;
  }

  // This script is inlined in <head>, so the body (and therefore the scene
  // elements) does not exist yet. Re-bind once the document is parsed.
  if(document.readyState === 'loading'){
    document.addEventListener('DOMContentLoaded', function(){
      geometryReady = false;
      initSceneEls();
      initSectionEls();
      request();
      // A deep link into the scene lands on a panel that is still hidden
      // until the scrub has run — jump to the end of the scene instead, so
      // the expertise panel arrives fully revealed.
      if((window.location.hash || '') === '#expertise' && sceneActive){
        jumpToExpertise();
      }
    });
  }

  window.addEventListener('scroll', request, {passive: true});
  window.addEventListener('resize', function(){ geometryReady = false; applyNoScene(); request(); });
  // Deep links / header nav link to '#expertise' resolve inside the pinned scene
  // where the panel is hidden until the scrub has run: scroll to the end of the
  // scene so the panel arrives fully revealed.
  document.addEventListener('click', function(e){
    var a = e.target && e.target.closest ? e.target.closest('a[href="#expertise"]') : null;
    if(!a || !sceneActive) return;
    e.preventDefault();
    jumpToExpertise();
  });
  // The visitor can turn reduced motion on while the page is open; the
  // scene must fall back to the stacked document immediately.
  if(reduceMQ && reduceMQ.addEventListener){
    reduceMQ.addEventListener('change', function(e){
      reduce = e.matches;
      applyNoScene();
      request();
    });
  }
  // Body-level mutations only: the AI chat mutates its own subtree constantly
  // and must not trigger a full scene + reveal sweep.
  function watchBody(){
    if(!document.body) return;
    try{
      new MutationObserver(request).observe(document.body, {childList: true, subtree: false});
    }catch(e){}
  }
  if(document.body){ watchBody(); }
  else { document.addEventListener('DOMContentLoaded', watchBody); }
  request();

  // ---- Section crossfade (MarqStrip → ... → Contact) ----
  // As a section leaves the viewport top it fades out (--section-out);
  // as the next enters from the bottom it fades in (--section-in).
  // The scene's hero→expertise scrub owns the first transition; this handles
  // everything after it. Disabled under reduced motion.
  var sectionSel = '.marquee, .about, .featured-project, .all-projects, .experience, .testimonials, .contact';
  var sectionEls = [];
  function initSectionEls(){
    sectionEls = [].slice.call(document.querySelectorAll(sectionSel));
    sectionEls.forEach(function(el){ el.classList.add('section-crossfade'); });
    applySectionCrossfade();
  }
  function applySectionCrossfade(){
    if(reduce || !sectionEls || sectionEls.length === 0) return;
    var vh = window.innerHeight || d.clientHeight;
    var scrollY = window.pageYOffset || d.scrollTop;

    // Single shared scroll progress p for the whole site (like hero->expertise).
    // p = 0 at top of first crossfade section, p = 1 at bottom of last.
    var firstEl = sectionEls[0];
    var lastEl = sectionEls[sectionEls.length - 1];
    if(!firstEl || !lastEl) return;
    var firstRect, lastRect;
    try{
      firstRect = firstEl.getBoundingClientRect();
      lastRect = lastEl.getBoundingClientRect();
    }catch(e){
      return;
    }
    var siteTop = firstRect.top + scrollY;
    var siteBottom = lastRect.bottom + scrollY;
    var siteHeight = siteBottom - siteTop;
    var p = siteHeight > 0 ? clamp01((scrollY - siteTop) / siteHeight) : 0;

    // Opacity crossfade stays viewport-based (sectionOut/sectionIn).
    for(var i=0;i<sectionEls.length;i++){
      var el = sectionEls[i];
      var r = el.getBoundingClientRect();
      var top = r.top;
      // Fade out once the section has actually left the top of the viewport
      // (use the bottom edge so tall sections don't vanish while on screen).
      var sectionOut = r.bottom < 0 ? easeOutCubic(clamp01(-r.bottom / (vh * 0.4))) : 0;
      // Fade in as the section's top edge enters from the bottom.
      var sectionIn = top < vh ? easeOutCubic(clamp01((vh - top) / (vh * 0.4))) : 0;
      var opacity = Math.min(sectionIn, 1 - sectionOut);
      el.style.setProperty('--section-opacity', opacity.toFixed(3));
    }

    // Blur/scale/reveal driven by single shared p, divided into per-section chunks.
    // Within each chunk: first half = children reveal (unblur+scale up card-by-card),
    // second half = section recedes (blur+scale down). Sequential: section reveals
    // then recedes, then next section reveals — matches hero->expertise choreography.
    var n = sectionEls.length;
    var sectionSize = 1 / n;
    for(var i=0;i<n;i++){
      var el = sectionEls[i];
      var sectionStartP = i * sectionSize;
      var sectionP = clamp01((p - sectionStartP) / sectionSize);

      if(sectionP < 0.5){
        // Reveal phase: section entering — children unblur + scale up card-by-card.
        var revealP = sectionP * 2;
        var children = el.querySelectorAll('.reveal');
        for(var c=0;c<children.length;c++){
          var child = children[c];
          var st = child.getAttribute('data-stagger-index');
          var childIdx = st !== null ? parseInt(st, 10) : c;
          var childReveal = easeOutCubic(clamp01((revealP - childIdx * 0.12) / 0.18));
          var childBlur = 4 * (1 - childReveal);
          child.style.setProperty('--child-reveal', childReveal.toFixed(3));
          child.style.setProperty('--child-blur', childBlur.toFixed(2) + 'px');
          child.style.setProperty('--child-scale', (1 - 0.05 * (1 - childReveal)).toFixed(4));
        }
        el.style.setProperty('--section-blur', '0px');
        el.style.setProperty('--section-scale', '1');
      } else {
        // Recede phase: section leaving — blur + scale down.
        var recedeP = (sectionP - 0.5) * 2;
        el.style.setProperty('--section-blur', (4 * recedeP).toFixed(2) + 'px');
        el.style.setProperty('--section-scale', (1 - 0.05 * recedeP).toFixed(4));
      }
    }
  }

  // Kick off section crossfade right away if the body is already parsed
  // (e.g. this IIFE runs after DOMContentLoaded). If not, the DOMContentLoaded
  // handler above will call initSectionEls() instead.
  if(document.body){ initSectionEls(); }

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
  // Re-attach on DOM changes (hydration). Debounced to one pass per frame:
  // the AI chat mutates its subtree on every keystroke.
  var emailTick = false;
  function scheduleEmail(){
    if(emailTick) return;
    emailTick = true;
    requestAnimationFrame(function(){ emailTick = false; attachEmailFallback(); });
  }
  function watchMail(){
    if(!document.body) return;
    try{ new MutationObserver(scheduleEmail).observe(document.body,{childList:true,subtree:true}); }catch(e){}
  }
  if(document.body){ watchMail(); }
  else { document.addEventListener('DOMContentLoaded', watchMail); }
})();
""";

/// Full-page animated background via Vanta.globe (globe style), with the
/// original dot-matrix as fallback if Vanta fails to load. Animates with or
/// without cursor movement. Custom cursor (dot + trailing ring) is layered
/// on top. Both are disabled on touch/coarse pointers and under reduced motion.
const String _bgJs = """
(function(){
  function boot(){
    var d=document.documentElement;
    var reduceMQ=window.matchMedia?window.matchMedia('(prefers-reduced-motion: reduce)'):null;
    function reduced(){ return !!(reduceMQ&&reduceMQ.matches); }
    function coarse(){ return window.matchMedia&&window.matchMedia('(pointer: coarse)').matches; }
    var touch=coarse();

    // ---- Custom cursor ----
    var dot=document.querySelector('.cursor-dot');
    var ring=document.querySelector('.cursor-ring');
    var usable=!!(dot&&ring&&!touch&&('PointerEvent' in window||'onmousemove' in window));
    var mx=-100,my=-100,rx=-100,ry=-100,shown=false;
    var cursorRaf=0;
    function cursorFrame(){
      cursorRaf=0;
      if(reduced()){
        if(cursorRaf){cancelAnimationFrame(cursorRaf); cursorRaf=0;}
        return;
      }
      rx+=(mx-rx)*0.45; ry+=(my-ry)*0.45;
      dot.style.transform='translate('+(mx-4)+'px,'+(my-4)+'px)';
      ring.style.transform='translate('+(rx-17)+'px,'+(ry-17)+'px)';
      cursorRaf=requestAnimationFrame(cursorFrame);
    }
    function startCursor(){ if(usable&&!cursorRaf&&!reduced()) cursorRaf=requestAnimationFrame(cursorFrame); }
    if(usable){
      document.addEventListener('mousemove',function(e){ mx=e.clientX; my=e.clientY; if(!shown){shown=true;dot.style.opacity='1';ring.style.opacity='1';} },{passive:true});
      document.addEventListener('mouseover',function(e){ var t=e.target; if(t&&t.closest&&t.closest('a,button,.card,input,textarea')) ring.classList.add('is-hover'); });
      document.addEventListener('mouseout',function(e){ var t=e.target; if(t&&t.closest&&t.closest('a,button,.card,input,textarea')) ring.classList.remove('is-hover'); });
    }

    // ---- Background canvas ----
    var cv=document.getElementById('bg-canvas');
    if(!cv&&document.body){ cv=document.createElement('canvas'); cv.id='bg-canvas'; cv.className='bg-canvas'; cv.setAttribute('aria-hidden','true'); document.body.insertBefore(cv,document.body.firstChild); }
    if(!cv) return;

    var vantaObj=null;
    var INK='#23251d', CANVAS='#eeefe9';
    function refreshColors(){
      var cs=getComputedStyle(d);
      INK=cs.getPropertyValue('--ink').trim()||INK;
      CANVAS=cs.getPropertyValue('--canvas').trim()||CANVAS;
      if(vantaObj){
        vantaObj.setOptions({highlightColor: hexNum(INK), baseColor: hexNum(CANVAS), backgroundColor: hexNum(CANVAS)});
      }
    }
    refreshColors();
    new MutationObserver(refreshColors).observe(d,{attributes:true,attributeFilter:['data-theme']});

    function hexToRgb(h){ h=h.replace('#',''); if(h.length===3){ h=h.charAt(0)+h.charAt(0)+h.charAt(1)+h.charAt(1)+h.charAt(2)+h.charAt(2); } var n=parseInt(h,16); return [(n>>16)&255,(n>>8)&255,n&255]; }
    function hexNum(hex){ var rgb=hexToRgb(hex); return (rgb[0]<<16)|(rgb[1]<<8)|rgb[2]; }

    // ---- Dot-matrix fallback (only if Vanta is unavailable) ----
    var SP=touch?42:28, W=0, H=0, dots=[], mouse2={x:-99999,y:-99999};
    var ctx=null, canvasRaf=0;
    function resizeDots(){
      var dpr=Math.min(window.devicePixelRatio||1,1.5);
      var cw=window.innerWidth, ch=window.innerHeight;
      cv.width=Math.round(cw*dpr); cv.height=Math.round(ch*dpr);
      cv.style.width=cw+"px"; cv.style.height=ch+"px";
      if(ctx) ctx.setTransform(dpr,0,0,dpr,0,0);
      W=cw; H=ch;
      dots=[];
      var ix=Math.floor(W/SP), iy=Math.floor(H/SP);
      for(var i=0;i<ix;i++)for(var j=0;j<iy;j++)
        dots.push({x:i*SP+SP/2+(Math.random()-0.5)*5, y:j*SP+SP/2+(Math.random()-0.5)*5, ph:Math.random()*6.2832});
    }
    function startDotMatrix(){
      if(vantaObj||!cv.getContext) return;
      ctx=cv.getContext('2d');
      resizeDots();
      window.addEventListener('resize',resizeDots);
      window.addEventListener('mousemove',function(e){ mouse2.x=e.clientX; mouse2.y=e.clientY; },{passive:true});
      window.addEventListener('mouseout',function(e){ if(!e.relatedTarget){mouse2.x=-99999;mouse2.y=-99999;} });
      canvasRaf=requestAnimationFrame(drawDots);
    }
    function drawDots(t){
      canvasRaf=0;
      if(vantaObj){ return; }
      if(reduced()){ cv.style.display='none'; return; }
      if(t===undefined)t=performance.now();
      ctx.clearRect(0,0,W,H);
      var RD=140, time=t;
      for(var i=0;i<dots.length;i++){ var p=dots[i];
        p.x+=Math.sin(time*0.00012+p.ph)*0.02;
        p.y+=Math.cos(time*0.00017+p.ph)*0.02;
        var dx=p.x-mouse2.x, dy=p.y-mouse2.y;
        var dist=Math.sqrt(dx*dx+dy*dy);
        var n=Math.max(0,1-dist/RD);
        var a=0.10+n*0.55;
        var s=1+n*3.2;
        ctx.beginPath(); ctx.arc(p.x,p.y,s,0,6.2832);
        var rgb=hexToRgb(INK);
        ctx.fillStyle='rgba('+rgb[0]+','+rgb[1]+','+rgb[2]+','+Math.min(1,a)+')';
        ctx.fill();
      }
      canvasRaf=requestAnimationFrame(drawDots);
    }

    function startVanta(){
      if(vantaObj){ vantaObj.destroy(); vantaObj=null; }
      if(reduced()){ return; }
      if(typeof window.VANTA==='undefined'){ startDotMatrix(); return; }
      try{
        vantaObj=window.VANTA.GLOBE({
          el: cv,
          mouseControls: true,
          touchControls: false,
          minHeight: 200.00,
          minWidth: 200.00,
          highlightColor: hexNum(INK),
          baseColor: hexNum(CANVAS),
          backgroundColor: hexNum(CANVAS),
          points: 700,
          maxDistance: 40000,
          speed: 1.0,
        });
      }catch(e){
        vantaObj=null;
        startDotMatrix();
      }
    }

    // ---- Follow the motion preference while the page is open ----
    function applyMotion(){
      if(reduced()){
        if(vantaObj){ vantaObj.destroy(); vantaObj=null; }
        if(canvasRaf){ cancelAnimationFrame(canvasRaf); canvasRaf=0; }
        if(cursorRaf){ cancelAnimationFrame(cursorRaf); cursorRaf=0; }
        cv.style.display='none';
        d.classList.remove('has-custom-cursor');
        return;
      }
      cv.style.display='';
      if(usable){ d.classList.add('has-custom-cursor'); }
      startVanta();
      startCursor();
    }
    applyMotion();
    if(reduceMQ&&reduceMQ.addEventListener){ reduceMQ.addEventListener('change',applyMotion); }
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
        // three.js + Vanta.globe for the animated full-page background.
        // Loaded via CDN; _bgJs falls back to the dot-matrix if they don't arrive.
        script(attributes: {'src': 'https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js', 'defer': ''}),
        script(attributes: {'src': 'https://cdn.jsdelivr.net/npm/vanta@0.0.8/dist/vanta.globe.min.js', 'defer': ''}),
        script(attributes: {'defer': ''}, content: _bgJs),
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
        // Warm the resume PDF before the visitor clicks "Open CV" so it opens
        // faster (currently a ~5-19s cold load).
        link(
          rel: 'prefetch',
          href: '/assets/Resume.pdf',
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
