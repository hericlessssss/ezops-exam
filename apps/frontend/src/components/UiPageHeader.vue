<template>
  <div class="ui-page-header">
    <h1 class="title">{{ title }}</h1>
    <p v-if="subtitle" class="subtitle">{{ subtitle }}</p>
  </div>
</template>

<script>
export default {
  name: 'UiPageHeader',
  props: {
    title: { type: String, required: true },
    subtitle: { type: String, default: '' }
  }
}
</script>

<style lang="scss" scoped>
.ui-page-header {
  margin-bottom: 30px;
  
  .title {
    margin-bottom: 8px;
    font-size: 32px;
    font-weight: 700;
  }
  
  .subtitle {
    font-size: 18px;
    color: #666;
  }
}
</style>
