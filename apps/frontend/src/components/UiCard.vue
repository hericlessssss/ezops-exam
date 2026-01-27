<template>
  <div class="ui-card">
    <div v-if="$slots.header || title" class="ui-card-header">
      <slot name="header">
        <h3 v-if="title">{{ title }}</h3>
      </slot>
    </div>
    <div class="ui-card-body">
      <slot></slot>
    </div>
    <div v-if="$slots.footer" class="ui-card-footer">
      <slot name="footer"></slot>
    </div>
  </div>
</template>

<script>
export default {
  name: 'UiCard',
  props: {
    title: { type: String, default: '' }
  }
}
</script>

<style lang="scss" scoped>
.ui-card {
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  overflow: hidden;
  margin-bottom: 20px;

  &-header {
    padding: 16px 20px;
    border-bottom: 1px solid #eee;
    
    h3 {
      margin: 0;
      font-size: 18px;
    }
  }

  &-body {
    padding: 20px;
  }

  &-footer {
    padding: 12px 20px;
    background: #f9f9f9;
    border-top: 1px solid #eee;
  }
}
</style>
