<!doctype html>
<html lang="ja">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1" />
<title>Sansoukai Preview</title>

<style>
  :root{
    --bg:#0b0f1a;
    --panel: rgba(255,255,255,.08);
    --panel2: rgba(255,255,255,.06);
    --stroke: rgba(255,255,255,.12);
    --text: rgba(255,255,255,.92);
    --muted: rgba(255,255,255,.62);
    --good: rgba(123,255,198,.95);
    --warn: rgba(255,214,102,.95);
    --danger: rgba(255,120,120,.95);

    --imgH: 360px;
    --gap: 44px;
    --duration: 70s;
    --zoom: 1.06;
    --slideFade: 0.65s;
  }

  *{ box-sizing:border-box; }
  body{
    margin:0;
    background:
      radial-gradient(1200px 700px at 20% 10%, #18244a 0%, var(--bg) 55%),
      radial-gradient(900px 500px at 85% 20%, #2a1653 0%, transparent 60%),
      var(--bg);
    color:var(--text);
    font: 14px/1.4 system-ui, -apple-system, "Segoe UI", sans-serif;
    overflow:hidden;
  }

  .app{
    position:fixed; inset:0;
    display:grid;
    grid-template-columns: 420px 1fr;
    gap:16px;
    padding:16px;
  }

  .panel{
    background: linear-gradient(180deg, var(--panel), var(--panel2));
    border:1px solid var(--stroke);
    border-radius:22px;
    box-shadow: 0 24px 90px rgba(0,0,0,.40);
    backdrop-filter: blur(14px);
    overflow:hidden;
  }

  /* LEFT */
  .left{
    display:flex;
    flex-direction:column;
    height: calc(100vh - 32px);
  }

  .leftTop{
    padding:12px;
    border-bottom:1px solid var(--stroke);
  }

  .drop{
    border:1px dashed rgba(255,255,255,.20);
    background: rgba(0,0,0,.16);
    border-radius:18px;
    padding:12px;
    display:grid;
    gap:10px;
  }

  .dropHeader{
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:10px;
  }

  .stats{
    display:flex;
    gap:8px;
    flex-wrap:wrap;
    align-items:center;
  }

  .chip{
    padding:6px 10px;
    border:1px solid var(--stroke);
    border-radius:999px;
    color:var(--muted);
    font-size:12px;
    background:rgba(0,0,0,.18);
    white-space:nowrap;
  }

  .btn{
    appearance:none;
    border:1px solid var(--stroke);
    background:rgba(0,0,0,.18);
    color:var(--text);
    border-radius:14px;
    padding:10px 12px;
    cursor:pointer;
    font-weight:900;
    transition: transform .08s ease, background .15s ease, border-color .15s ease, opacity .15s ease;
  }
  .btn:active{ transform: translateY(1px) scale(.99); }
  .btn.good{ border-color: rgba(123,255,198,.40); }
  .btn.warn{ border-color: rgba(255,214,102,.40); }
  .btn.danger{ border-color: rgba(255,120,120,.40); }
  .btn:disabled{ opacity:.45; cursor:not-allowed; }

  .fileRow{
    display:grid;
    grid-template-columns: 1fr auto auto;
    gap:10px;
    align-items:center;
  }
  input[type="file"]{ width:100%; }

  .hint{
    color:rgba(255,255,255,.55);
    font-size:12px;
  }

  .controls{
    padding:12px;
    border-bottom:1px solid var(--stroke);
    display:grid;
    gap:10px;
  }

  .ctrlRow{
    display:grid;
    grid-template-columns: 1fr auto;
    gap:10px;
    align-items:center;
  }
  input[type="range"]{ width:100%; }

  .btnRow{
    display:flex;
    gap:10px;
  }
  .btnRow .btn{ flex:1; }

  .toggleRow{
    display:flex;
    gap:10px;
  }
  .toggleRow .btn{ flex:1; }

  .leftBottom{
    padding:12px;
    overflow:auto;
    display:grid;
    gap:12px;
  }

  .sectionTitle{
    font-weight:950;
    color:rgba(255,255,255,.78);
    font-size:12px;
    letter-spacing:.2px;
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:10px;
  }

  /* Presets list */
  .presets{
    display:grid;
    grid-template-columns: repeat(2, 1fr);
    gap:10px;
  }
  .pbtn{
    border:1px solid rgba(255,255,255,.12);
    background: rgba(0,0,0,.16);
    color:var(--text);
    border-radius:16px;
    padding:10px 12px;
    cursor:pointer;
    font-weight:900;
    text-align:left;
    display:grid;
    gap:6px;
    min-height:84px;
    transition: background .15s ease, border-color .15s ease, transform .1s ease;
  }
  .pbtn:active{ transform: translateY(1px) scale(.995); }
  .pbtn .top{
    display:flex;
    align-items:baseline;
    justify-content:space-between;
    gap:10px;
  }
  .pbtn .id{ font-weight:1000; font-size:14px; letter-spacing:.3px; }
  .pbtn .mini{ color:var(--muted); font-size:12px; font-weight:850; }
  .pbtn .desc{ color:rgba(255,255,255,.72); font-size:12px; font-weight:750; line-height:1.25; }
  .pbtn.active{
    border-color: rgba(123,255,198,.55);
    box-shadow: 0 0 0 2px rgba(123,255,198,.14) inset;
    background: rgba(255,255,255,.06);
  }

  /* Queue (order) */
  .queue{
    border:1px solid rgba(255,255,255,.10);
    background: rgba(0,0,0,.14);
    border-radius:18px;
    overflow:hidden;
  }
  .queueHead{
    padding:10px 12px;
    border-bottom:1px solid rgba(255,255,255,.08);
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:10px;
  }
  .queueList{
    max-height: 220px;
    overflow:auto;
    padding:6px;
    display:grid;
    gap:6px;
  }
  .qitem{
    display:grid;
    grid-template-columns: 54px 1fr auto;
    gap:10px;
    align-items:center;
    border:1px solid rgba(255,255,255,.10);
    background: rgba(0,0,0,.16);
    border-radius:14px;
    padding:6px 8px;
    cursor:grab;
    user-select:none;
  }
  .qthumb{
    width:54px; height:38px;
    border-radius:10px;
    border:1px solid rgba(255,255,255,.10);
    overflow:hidden;
    background: rgba(255,255,255,.05);
    display:grid;
    place-items:center;
  }
  .qthumb img{
    width:100%; height:100%;
    object-fit:cover;
    display:block;
  }
  .qmeta{
    display:flex;
    flex-direction:column;
    gap:2px;
    min-width:0;
  }
  .qname{
    font-weight:900;
    font-size:12px;
    overflow:hidden;
    text-overflow:ellipsis;
    white-space:nowrap;
  }
  .qsub{
    color:rgba(255,255,255,.55);
    font-size:11px;
    overflow:hidden;
    text-overflow:ellipsis;
    white-space:nowrap;
  }
  .qactions{
    display:flex;
    gap:6px;
    align-items:center;
  }
  .iconBtn{
    width:34px; height:34px;
    border-radius:12px;
    border:1px solid rgba(255,255,255,.12);
    background: rgba(0,0,0,.18);
    color:rgba(255,255,255,.86);
    cursor:pointer;
    font-weight:950;
  }
  .iconBtn:active{ transform: translateY(1px); }
  .qitem.dragging{ opacity:.55; }
  .qitem.over{ outline:2px solid rgba(123,255,198,.35); }

  /* RIGHT (preview) */
  .right{ position:relative; }

  .stage{
    position:absolute; inset:0;
    overflow:hidden;
    background: linear-gradient(180deg, rgba(255,255,255,.04), rgba(0,0,0,.08));
    border-radius:22px;
  }

  .fade{
    position:absolute; inset:0; pointer-events:none;
    background: linear-gradient(90deg,
      rgba(11,15,26,1) 0%,
      rgba(11,15,26,0) 12%,
      rgba(11,15,26,0) 88%,
      rgba(11,15,26,1) 100%);
    opacity:.85;
  }

  /* Conveyor track */
  .track{
    position:absolute;
    top:50%;
    left:0;
    transform: translateY(-50%);
    display:flex;
    align-items:center;
    gap: var(--gap);
    padding-left: 8vw;
    will-change: transform;
  }
  .card{
    flex:0 0 auto;
    border-radius:18px;
    overflow:hidden;
    background:rgba(255,255,255,.06);
    border:1px solid rgba(255,255,255,.10);
    box-shadow: 0 18px 70px rgba(0,0,0,.35);
  }
  .card img{
    height: var(--imgH);
    width:auto;
    display:block;
  }

  /* Grid */
  .gridWrap{
    position:absolute; inset:0;
    display:none;
    place-items:center;
  }
  .grid{
    display:grid;
    grid-template-columns: repeat(5, auto);
    gap:16px;
    padding: 24px;
    align-items:center;
    justify-content:center;
  }
  .grid .card img{ height: 210px; }

  /* Single slideshow */
  .singleWrap{
    position:absolute; inset:0;
    display:none;
    place-items:center;
  }
  .singleFrame{
    border-radius:22px;
    overflow:hidden;
    border:1px solid rgba(255,255,255,.10);
    box-shadow: 0 24px 90px rgba(0,0,0,.45);
    background: rgba(0,0,0,.12);
  }
  .singleImg{
    display:block;
    height: min(70vh, 520px);
    width:auto;
    opacity:1;
    transition: opacity var(--slideFade) ease;
  }

  /* Pause */
  .paused .track{ animation-play-state: paused !important; }
  .paused .card{ animation-play-state: paused !important; }
  .paused .grid .card{ animation-play-state: paused !important; }
  .paused .singleImg{ animation-play-state: paused !important; }

  /* small */
  @media (max-width: 980px){
    .app{ grid-template-columns:1fr; }
    .left{ height: auto; }
    .grid{ grid-template-columns: repeat(3, auto); }
  }
</style>

<style id="dyn"></style>
</head>

<body>
<div class="app">
  <!-- LEFT -->
  <section class="panel left">
    <div class="leftTop">
      <div class="drop" id="drop">
        <div class="dropHeader">
          <div class="stats">
            <span class="chip">枚数 <span id="count">0</span></span>
            <span class="chip">候補 <span id="presetCount">0</span></span>
          </div>
          <button class="btn danger" id="clear" title="全削除">全消し</button>
        </div>

        <!-- 追加は左に（ここ） -->
        <div class="fileRow">
          <input id="files" type="file" accept="image/*" multiple />
          <button class="btn good" id="add" title="Aでも追加できる">追加</button>
          <button class="btn warn" id="shuffle" title="Sでシャッフル">混ぜる</button>
        </div>

        <div class="hint">ドラッグ&ドロップで追加可（この枠に落とす）</div>
      </div>
    </div>

    <div class="controls">
      <div class="ctrlRow">
        <input id="dur" type="range" min="25" max="220" value="70" />
        <span class="chip" id="durL">70s</span>
      </div>
      <div class="ctrlRow">
        <input id="h" type="range" min="180" max="520" value="360" />
        <span class="chip" id="hL">360</span>
      </div>
      <div class="ctrlRow">
        <input id="gap" type="range" min="12" max="90" value="44" />
        <span class="chip" id="gapL">44</span>
      </div>

      <div class="toggleRow">
        <button class="btn" id="toggle" title="Spaceで再生/停止">⏸ 再生</button>
        <button class="btn" id="next" title="→で次（単体モード用）">次 ▶</button>
      </div>
    </div>

    <div class="leftBottom">
      <div class="sectionTitle">
        <span>アニメーション</span>
        <span class="chip">1-9で切替</span>
      </div>
      <div class="presets" id="presetBtns"></div>

      <div class="sectionTitle">
        <span>順番（ドラッグで入れ替え）</span>
        <span class="chip">クリックで削除</span>
      </div>
      <div class="queue">
        <div class="queueHead">
          <span class="chip">先頭から流れる</span>
          <div style="display:flex; gap:8px;">
            <button class="btn" id="reverse" title="逆順">逆</button>
            <button class="btn" id="sort" title="名前順">整列</button>
          </div>
        </div>
        <div class="queueList" id="queueList"></div>
      </div>
    </div>
  </section>

  <!-- RIGHT -->
  <section class="panel right">
    <div class="stage play" id="stage">
      <div class="track" id="track"></div>

      <div class="gridWrap" id="gridWrap">
        <div class="grid" id="grid"></div>
      </div>

      <div class="singleWrap" id="singleWrap">
        <div class="singleFrame">
          <img id="singleImg" class="singleImg" alt="" />
        </div>
      </div>

      <div class="fade" id="fade"></div>
    </div>
  </section>
</div>

<script>
  // ===============================
  //  Presets
  // ===============================
  const PRESETS = [
    { id:"A", label:"直線", desc:"一定速度で静かに横へ流れる", mode:"track", css:`
      .fade{ background: linear-gradient(90deg, rgba(11,15,26,1) 0%, rgba(11,15,26,0) 12%, rgba(11,15,26,0) 88%, rgba(11,15,26,1) 100%); }
      .track{ flex-direction:row; top:50%; left:0; transform: translateY(-50%); padding-left:8vw; }
      .play .track{ animation: moveX var(--duration) linear infinite; }
      @keyframes moveX{ from{ transform: translate(-55vw,-50%);} to{ transform: translate(55vw,-50%);} }
    `},
    { id:"D", label:"弱ズーム", desc:"写真がごくゆっくりズームしながら流れる", mode:"track", css:`
      .fade{ background: linear-gradient(90deg, rgba(11,15,26,1) 0%, rgba(11,15,26,0) 12%, rgba(11,15,26,0) 88%, rgba(11,15,26,1) 100%); }
      .track{ flex-direction:row; top:50%; left:0; transform: translateY(-50%); padding-left:8vw; }
      .play .track{ animation: moveX var(--duration) linear infinite; }
      @keyframes moveX{ from{ transform: translate(-55vw,-50%);} to{ transform: translate(55vw,-50%);} }
      .play .card img{ animation: kb 12s ease-in-out infinite; transform-origin: 50% 50%; }
      .play .card:nth-child(2n) img{ animation-duration: 13.5s; transform-origin: 40% 55%; }
      .play .card:nth-child(3n) img{ animation-duration: 15s; transform-origin: 60% 45%; }
      @keyframes kb{ 0%,100%{ transform: scale(1);} 50%{ transform: scale(var(--zoom)); } }
    `},
    { id:"N", label:"主役", desc:"順番に主役っぽく見せながら流れる", mode:"track", css:`
      .fade{ background: linear-gradient(90deg, rgba(11,15,26,1) 0%, rgba(11,15,26,0) 12%, rgba(11,15,26,0) 88%, rgba(11,15,26,1) 100%); }
      .track{ flex-direction:row; top:50%; left:0; transform: translateY(-50%); padding-left:8vw; }
      .play .track{ animation: pauseMove var(--duration) linear infinite; }
      @keyframes pauseMove{
        0%   { transform: translate(-55vw,-50%); }
        42%  { transform: translate(-6vw,-50%); }
        58%  { transform: translate( 6vw,-50%); }
        100% { transform: translate(55vw,-50%); }
      }
      .play .card{ animation: shine 9.0s ease-in-out infinite; opacity:.86; }
      .play .card:nth-child(1){ animation-delay:0s }
      .play .card:nth-child(2){ animation-delay:.9s }
      .play .card:nth-child(3){ animation-delay:1.8s }
      .play .card:nth-child(4){ animation-delay:2.7s }
      .play .card:nth-child(5){ animation-delay:3.6s }
      .play .card:nth-child(6){ animation-delay:4.5s }
      .play .card:nth-child(7){ animation-delay:5.4s }
      .play .card:nth-child(8){ animation-delay:6.3s }
      .play .card:nth-child(9){ animation-delay:7.2s }
      .play .card:nth-child(10){ animation-delay:8.1s }
      @keyframes shine{
        0%,100%{ transform: translateY(0) scale(1); filter: brightness(.98); opacity:.80; }
        35%{ transform: translateY(-7px) scale(1.03); filter: brightness(1.10); opacity:1; }
        70%{ transform: translateY(0) scale(1); filter: brightness(1.01); opacity:.9; }
      }
    `},
    { id:"F", label:"並べる", desc:"並べた写真が順番に目立つ", mode:"grid", css:`
      .gridWrap{ display:grid !important; }
      .singleWrap{ display:none !important; }
      .track{ display:none !important; }
      .fade{ background: linear-gradient(90deg, rgba(11,15,26,1) 0%, rgba(11,15,26,0) 12%, rgba(11,15,26,0) 88%, rgba(11,15,26,1) 100%); }
      .play .grid .card{ animation: glow 7.5s ease-in-out infinite; opacity:.75; }
      .play .grid .card:nth-child(1){ animation-delay:0s }
      .play .grid .card:nth-child(2){ animation-delay:1.0s }
      .play .grid .card:nth-child(3){ animation-delay:2.0s }
      .play .grid .card:nth-child(4){ animation-delay:3.0s }
      .play .grid .card:nth-child(5){ animation-delay:4.0s }
      .play .grid .card:nth-child(6){ animation-delay:5.0s }
      .play .grid .card:nth-child(7){ animation-delay:6.0s }
      .play .grid .card:nth-child(8){ animation-delay:7.0s }
      .play .grid .card:nth-child(9){ animation-delay:8.0s }
      .play .grid .card:nth-child(10){ animation-delay:9.0s }
      @keyframes glow{
        0%,100%{ transform: scale(1); opacity:.70; }
        35%{ transform: scale(1.05); opacity:1; box-shadow: 0 26px 90px rgba(0,0,0,.45); }
        60%{ transform: scale(1); opacity:.82; }
      }
    `},
    { id:"O", label:"単体", desc:"1枚ずつ切り替わって表示される", mode:"single", css:`
      .singleWrap{ display:grid !important; }
      .gridWrap{ display:none !important; }
      .track{ display:none !important; }
      .fade{ background: radial-gradient(1200px 600px at 50% 20%, rgba(255,255,255,.08), rgba(11,15,26,1) 60%); opacity:.9; }
    `},
    { id:"P", label:"単体ズ", desc:"1枚ずつ＋ごく弱いズームで切替", mode:"single", css:`
      .singleWrap{ display:grid !important; }
      .gridWrap{ display:none !important; }
      .track{ display:none !important; }
      .fade{ background: radial-gradient(1200px 600px at 50% 20%, rgba(255,255,255,.08), rgba(11,15,26,1) 60%); opacity:.9; }
      .play #singleImg{ animation: szoom 6.8s ease-in-out infinite; transform-origin: 52% 48%; }
      @keyframes szoom{ 0%,100%{ transform: scale(1); } 50%{ transform: scale(1.035); } }
    `},
    { id:"Q", label:"縦", desc:"上から下へゆっくり流れる", mode:"track", css:`
      .track{ flex-direction: column; top:8vh; left:50%; transform: translate(-50%,0); padding-left:0; }
      .fade{ background: linear-gradient(180deg, rgba(11,15,26,1) 0%, rgba(11,15,26,0) 12%, rgba(11,15,26,0) 88%, rgba(11,15,26,1) 100%); }
      .play .track{ animation: moveY var(--duration) linear infinite; }
      @keyframes moveY{ from{ transform: translate(-50%,-40vh);} to{ transform: translate(-50%,40vh);} }
    `},
    { id:"R", label:"斜め", desc:"斜めにゆっくり流れていく", mode:"track", css:`
      .fade{ background: linear-gradient(90deg, rgba(11,15,26,1) 0%, rgba(11,15,26,0) 12%, rgba(11,15,26,0) 88%, rgba(11,15,26,1) 100%); }
      .track{ flex-direction:row; top:50%; left:0; transform: translateY(-50%); padding-left:8vw; }
      .play .track{ animation: diag var(--duration) linear infinite; }
      @keyframes diag{
        from{ transform: translate(-55vw,-50%) translateY(10px); }
        to  { transform: translate( 55vw,-50%) translateY(-10px); }
      }
      .play .card{ animation: drift 7.4s ease-in-out infinite; }
      .play .card:nth-child(2n){ animation-duration: 8.2s; }
      .play .card:nth-child(3n){ animation-duration: 9.0s; }
      @keyframes drift{
        0%,100%{ transform: rotate(-.12deg) translateY(0px); opacity:.94; }
        50%{ transform: rotate(.12deg) translateY(-4px); opacity:1; }
      }
    `},
  ];

  // ===============================
  //  DOM
  // ===============================
  const drop = document.getElementById('drop');
  const files = document.getElementById('files');
  const addBtn = document.getElementById('add');
  const clearBtn = document.getElementById('clear');
  const shuffleBtn = document.getElementById('shuffle');

  const countEl = document.getElementById('count');
  const presetCount = document.getElementById('presetCount');

  const dur = document.getElementById('dur');
  const durL = document.getElementById('durL');
  const h = document.getElementById('h');
  const hL = document.getElementById('hL');
  const gap = document.getElementById('gap');
  const gapL = document.getElementById('gapL');

  const toggleBtn = document.getElementById('toggle');
  const nextBtn = document.getElementById('next');

  const reverseBtn = document.getElementById('reverse');
  const sortBtn = document.getElementById('sort');

  const stage = document.getElementById('stage');
  const track = document.getElementById('track');
  const gridWrap = document.getElementById('gridWrap');
  const grid = document.getElementById('grid');
  const singleWrap = document.getElementById('singleWrap');
  const singleImg = document.getElementById('singleImg');
  const queueList = document.getElementById('queueList');

  const dyn = document.getElementById('dyn');
  const presetBtns = document.getElementById('presetBtns');

  // ===============================
  //  State
  // ===============================
  let urls = []; // objectURLs
  let metas = []; // {name, size, type}
  let playing = true;
  let current = PRESETS[0];

  // single
  let slideTimer = null;
  let slideIndex = 0;

  // DnD reorder
  let dragIndex = -1;

  // ===============================
  //  Utils
  // ===============================
  presetCount.textContent = String(PRESETS.length);

  const setVars = () => {
    document.documentElement.style.setProperty('--duration', dur.value + 's');
    document.documentElement.style.setProperty('--imgH', h.value + 'px');
    document.documentElement.style.setProperty('--gap', gap.value + 'px');
    durL.textContent = dur.value + 's';
    hL.textContent = h.value;
    gapL.textContent = gap.value;
  };

  const setPlay = (on) => {
    playing = on;
    stage.classList.toggle('play', on);
    stage.classList.toggle('paused', !on);
    toggleBtn.textContent = on ? '⏸ 再生' : '▶ 停止';
    if (current.mode === 'single') {
      if (on) startSingle(); else stopSingle();
    }
  };

  const updateCount = () => { countEl.textContent = String(urls.length); };

  const revokeAll = () => {
    urls.forEach(u => { try{ URL.revokeObjectURL(u); }catch{} });
  };

  const makeCard = (src) => {
    const card = document.createElement('div');
    card.className = 'card';
    const img = document.createElement('img');
    img.src = src;
    card.appendChild(img);
    return card;
  };

  const renderTrack = () => {
    track.innerHTML = '';
    urls.forEach(u => track.appendChild(makeCard(u)));
  };

  const renderGrid = () => {
    grid.innerHTML = '';
    urls.forEach(u => grid.appendChild(makeCard(u)));
  };

  const bytes = (n) => {
    if (!Number.isFinite(n)) return '';
    const u = ['B','KB','MB','GB'];
    let i = 0, v = n;
    while (v >= 1024 && i < u.length-1){ v/=1024; i++; }
    return `${(i===0? v : v.toFixed(1))}${u[i]}`;
  };

  // ===============================
  //  Queue UI
  // ===============================
  const renderQueue = () => {
    queueList.innerHTML = '';
    urls.forEach((u, i) => {
      const m = metas[i] || {name:`#${i+1}`, size:0, type:''};
      const item = document.createElement('div');
      item.className = 'qitem';
      item.draggable = true;
      item.dataset.idx = String(i);

      item.addEventListener('dragstart', (e) => {
        dragIndex = i;
        item.classList.add('dragging');
        e.dataTransfer.effectAllowed = 'move';
      });
      item.addEventListener('dragend', () => {
        item.classList.remove('dragging');
        dragIndex = -1;
        document.querySelectorAll('.qitem').forEach(x => x.classList.remove('over'));
      });
      item.addEventListener('dragover', (e) => {
        e.preventDefault();
        item.classList.add('over');
      });
      item.addEventListener('dragleave', () => item.classList.remove('over'));
      item.addEventListener('drop', (e) => {
        e.preventDefault();
        item.classList.remove('over');
        const to = i;
        if (dragIndex < 0 || dragIndex === to) return;
        moveItem(dragIndex, to);
      });

      const thumb = document.createElement('div');
      thumb.className = 'qthumb';
      const img = document.createElement('img');
      img.src = u;
      thumb.appendChild(img);

      const meta = document.createElement('div');
      meta.className = 'qmeta';
      const name = document.createElement('div');
      name.className = 'qname';
      name.textContent = `${i+1}. ${m.name || 'image'}`;
      const sub = document.createElement('div');
      sub.className = 'qsub';
      sub.textContent = `${bytes(m.size)} ${m.type || ''}`.trim();
      meta.appendChild(name);
      meta.appendChild(sub);

      const actions = document.createElement('div');
      actions.className = 'qactions';
      const del = document.createElement('button');
      del.className = 'iconBtn';
      del.title = '削除';
      del.textContent = '✕';
      del.addEventListener('click', () => removeAt(i));
      actions.appendChild(del);

      item.appendChild(thumb);
      item.appendChild(meta);
      item.appendChild(actions);

      queueList.appendChild(item);
    });
  };

  const moveItem = (from, to) => {
    const u = urls.splice(from, 1)[0];
    const m = metas.splice(from, 1)[0];
    urls.splice(to, 0, u);
    metas.splice(to, 0, m);
    slideIndex = Math.min(slideIndex, Math.max(0, urls.length-1));
    refreshAll();
  };

  const removeAt = (i) => {
    if (!urls[i]) return;
    try{ URL.revokeObjectURL(urls[i]); }catch{}
    urls.splice(i, 1);
    metas.splice(i, 1);
    slideIndex = Math.min(slideIndex, Math.max(0, urls.length-1));
    refreshAll();
  };

  const refreshAll = () => {
    updateCount();
    renderQueue();
    applyPreset(current); // rerender preview
    if (current.mode === 'single' && playing) startSingle();
  };

  // ===============================
  //  Single slideshow
  // ===============================
  const stopSingle = () => {
    if (slideTimer) { clearInterval(slideTimer); slideTimer = null; }
  };

  const showSingle = (idx) => {
    if (!urls.length) return;
    slideIndex = (idx + urls.length) % urls.length;
    singleImg.style.opacity = 0;
    setTimeout(() => {
      singleImg.src = urls[slideIndex];
      singleImg.style.opacity = 1;
    }, 80);
  };

  const startSingle = () => {
    stopSingle();
    if (!urls.length) return;
    showSingle(slideIndex);

    // durationを “全枚ざっくり1周” として1枚の間隔を算出
    const per = Math.max(2200, Math.floor((parseFloat(dur.value) * 1000) / Math.max(1, urls.length)));
    slideTimer = setInterval(() => {
      if (!playing) return;
      showSingle(slideIndex + 1);
    }, per);
  };

  // ===============================
  //  Preset apply
  // ===============================
  const applyPreset = (p) => {
    current = p;
    dyn.textContent = p.css;

    // active button
    document.querySelectorAll('.pbtn').forEach(b => b.classList.remove('active'));
    const btn = document.querySelector(`.pbtn[data-id="${p.id}"]`);
    if (btn) btn.classList.add('active');

    // view switch
    track.style.display = 'flex';
    gridWrap.style.display = 'none';
    singleWrap.style.display = 'none';

    stopSingle();

    if (p.mode === 'grid') {
      gridWrap.style.display = 'grid';
      track.style.display = 'none';
      singleWrap.style.display = 'none';
      renderGrid();
      return;
    }
    if (p.mode === 'single') {
      singleWrap.style.display = 'grid';
      track.style.display = 'none';
      gridWrap.style.display = 'none';
      if (playing) startSingle();
      return;
    }

    // track mode
    renderTrack();
  };

  // ===============================
  //  Add / clear / shuffle / sort
  // ===============================
  const appendFiles = (fileList) => {
    const list = Array.from(fileList || []);
    if (!list.length) return;

    const add = list.slice(0, 400);
    for (const f of add) {
      const url = URL.createObjectURL(f);
      urls.push(url);
      metas.push({ name: f.name || 'image', size: f.size || 0, type: f.type || '' });
    }

    // make it easy: after add -> auto refresh & play
    refreshAll();
    setPlay(true);
  };

  const shuffleOrder = () => {
    for (let i = urls.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [urls[i], urls[j]] = [urls[j], urls[i]];
      [metas[i], metas[j]] = [metas[j], metas[i]];
    }
    refreshAll();
    setPlay(true);
  };

  const reverseOrder = () => {
    urls.reverse();
    metas.reverse();
    refreshAll();
    setPlay(true);
  };

  const sortByName = () => {
    const packed = urls.map((u, i) => ({u, m: metas[i]}));
    packed.sort((a, b) => (a.m?.name || '').localeCompare((b.m?.name || ''), 'ja'));
    urls = packed.map(x => x.u);
    metas = packed.map(x => x.m);
    refreshAll();
    setPlay(true);
  };

  const clearAll = () => {
    stopSingle();
    revokeAll();
    urls = [];
    metas = [];
    track.innerHTML = '';
    grid.innerHTML = '';
    singleImg.removeAttribute('src');
    slideIndex = 0;
    files.value = '';
    refreshAll();
  };

  // ===============================
  //  Build preset buttons
  // ===============================
  PRESETS.forEach((p, i) => {
    const b = document.createElement('button');
    b.type = 'button';
    b.className = 'pbtn' + (i===0 ? ' active' : '');
    b.dataset.id = p.id;
    b.innerHTML = `
      <div class="top">
        <div class="id">${p.id}</div>
        <div class="mini">${p.label}</div>
      </div>
      <div class="desc">${p.desc}</div>
    `;
    b.addEventListener('click', () => applyPreset(p));
    presetBtns.appendChild(b);
  });

  // ===============================
  //  Events
  // ===============================
  addBtn.addEventListener('click', () => appendFiles(files.files));
  shuffleBtn.addEventListener('click', shuffleOrder);
  clearBtn.addEventListener('click', clearAll);
  reverseBtn.addEventListener('click', reverseOrder);
  sortBtn.addEventListener('click', sortByName);

  // drag & drop area
  drop.addEventListener('dragover', (e) => { e.preventDefault(); drop.style.borderColor = 'rgba(123,255,198,.60)'; });
  drop.addEventListener('dragleave', () => { drop.style.borderColor = ''; });
  drop.addEventListener('drop', (e) => {
    e.preventDefault();
    drop.style.borderColor = '';
    if (e.dataTransfer?.files?.length) appendFiles(e.dataTransfer.files);
  });

  // sliders
  const onVars = () => {
    setVars();
    if (current.mode === 'single' && playing) startSingle();
  };
  dur.addEventListener('input', onVars);
  h.addEventListener('input', onVars);
  gap.addEventListener('input', onVars);

  toggleBtn.addEventListener('click', () => setPlay(!playing));
  nextBtn.addEventListener('click', () => {
    if (current.mode === 'single') showSingle(slideIndex + 1);
  });

  window.addEventListener('keydown', (e) => {
    if (e.code === 'Space') { e.preventDefault(); setPlay(!playing); }
    if (e.key === 'ArrowRight') { if (current.mode === 'single') showSingle(slideIndex + 1); }
    if (e.key === 'ArrowLeft') { if (current.mode === 'single') showSingle(slideIndex - 1); }
    if (e.key === 'a' || e.key === 'A') appendFiles(files.files);
    if (e.key === 's' || e.key === 'S') shuffleOrder();

    const n = parseInt(e.key, 10);
    if (!isNaN(n) && n >= 1 && n <= PRESETS.length) applyPreset(PRESETS[n-1]);
  });

  // ===============================
  //  Init
  // ===============================
  setVars();
  refreshAll();
  applyPreset(PRESETS[0]);
  setPlay(true);
</script>
</body>
</html>
