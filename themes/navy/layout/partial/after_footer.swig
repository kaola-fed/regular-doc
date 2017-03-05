<!-- Scripts -->
<!-- build:js build/js/main.js -->
{{ js('js/toc') }}
{{ js('js/mobile_nav') }}
<!-- endbuild -->
<!-- Algolia -->
{% if config.algolia %}
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/docsearch.js/1.5.0/docsearch.min.js"></script>
<script type="text/javascript">
document.getElementById('search-input-wrap').classList.add('on');
docsearch({
  apiKey: '{{ config.algolia.api_key }}',
  indexName: '{{ config.algolia.index_name }}',
  inputSelector: '#search-input'
});
</script>
{% endif %}
