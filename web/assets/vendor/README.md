# Vendored background libraries

These files back the animated Vanta.js globe background. They are served from
this origin rather than a CDN on purpose: the previous attempt pinned
`vanta@0.0.8` from jsDelivr, that release was later pulled from npm, the
script 404'd, and the background silently fell back to nothing.

| File | Version | Source | License |
| --- | --- | --- | --- |
| `three.r134.min.js` | r134 | https://cdnjs.cloudflare.com/ajax/libs/three.js/r134/three.min.js | MIT (three.js) |
| `vanta.globe.min.js` | 0.5.24 | https://cdn.jsdelivr.net/npm/vanta@0.5.24/dist/vanta.globe.min.js | MIT (vanta.js) |

three.js r134 is the revision Vanta 0.5.x is built and tested against; the
Vanta package ships the same build under `vendor/three.r134.min.js`.

Do not edit these files. To move to a new upstream release, download the
replacement, confirm the globe still renders (see the background bullet in the
project README), and update the versions in the table above and the script tags
in `lib/main.server.dart`.
