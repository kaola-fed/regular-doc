<header id="banner" class="wrapper">
  <div class="inner">
    <h1 id="banner-name">{{ page.maintitle }}</h1>
    <h2 id="banner-title">{{ page.subtitle }}</h2>
    <div id="intro-get-started-wrap">
      <a href="https://github.com/regularjs/regular/archive/master.zip" id="intro-get-started-link" download>Download</a>
      <a href="docs/" id="intro-get-started-link" class="active">Get started</a>
    </div>
    <div id="banner-share">{{ partial('partial/share') }}</div>
  </div>
</header>
<div id="content-wrap">
  <div class="wrapper">
    <div class="inner">
      {{ page.content }}
      <ul id="intro-cmd-wrap">
        <li class="intro-cmd-item">// CDN</li>
        <li class="intro-cmd-item intro-cmd-symbol">https://unpkg.com/regularjs/dist/regular.min.js</li>
        <li class="intro-cmd-item">// NPM</li>
        <li class="intro-cmd-item intro-cmd-symbol">npm install regularjs</li>
      </ul>
      <iframe width="100%" height="300" src="//jsrun.net/EnpKp/embedded/all/light/" allowfullscreen="allowfullscreen" frameborder="0"></iframe>
      <div id="intro-get-started-wrap">
        <a href="docs/" id="intro-get-started-link">Get started</a>
      </div>
    </div>
  </div>
</div>