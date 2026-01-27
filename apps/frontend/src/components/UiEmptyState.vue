<template>
  <div class="ui-empty-state">
    <div class="icon-wrapper">
      <UiBaseIcon v-if="icon" :iconName="icon" width="64px" height="64px" color="#ccc" />
      <slot v-else name="icon"></slot>
    </div>
    <h3 class="title">{{ title }}</h3>
    <p class="description">{{ description }}</p>
    <div v-if="$slots.actions" class="actions">
      <slot name="actions"></slot>
    </div>
  </div>
</template>

<script>
import UiBaseIcon from './icons/UiBaseIcon.vue'

export default {
  name: 'UiEmptyState',
  components: { UiBaseIcon },
  props: {
    title: { type: String, default: 'No data found' },
    description: { type: String, default: 'There is nothing to show here at the moment.' },
    icon: { type: String, default: 'search' }
  }
}
</script>

<style lang="scss" scoped>
.ui-empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  text-align: center;

  .icon-wrapper {
    margin-bottom: 20px;
    opacity: 0.5;
  }

  .title {
    margin-bottom: 8px;
    font-size: 20px;
    color: #333;
  }

  .description {
    font-size: 16px;
    color: #666;
    max-width: 400px;
  }

  .actions {
    margin-top: 24px;
  }
}
</style>
