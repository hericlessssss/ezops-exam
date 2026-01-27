<template>
  <div class="ui-error-state">
    <div class="icon-wrapper">
      <UiBaseIcon iconName="error" width="64px" height="64px" color="#e01b3c" />
    </div>
    <h3 class="title">{{ title }}</h3>
    <p class="description">{{ message }}</p>
    <div class="actions">
      <button class="btn" @click="$emit('retry')">Try Again</button>
    </div>
  </div>
</template>

<script>
import UiBaseIcon from './icons/UiBaseIcon.vue'

export default {
  name: 'UiErrorState',
  components: { UiBaseIcon },
  props: {
    title: { type: String, default: 'Something went wrong' },
    message: { type: String, default: 'We encountered an error while loading the data.' }
  }
}
</script>

<style lang="scss" scoped>
.ui-error-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  text-align: center;

  .icon-wrapper {
    margin-bottom: 20px;
  }

  .title {
    margin-bottom: 8px;
    font-size: 20px;
    color: #e01b3c;
  }

  .description {
    font-size: 16px;
    color: #666;
    max-width: 400px;
    margin-bottom: 24px;
  }

  .btn {
    padding: 10px 24px;
    border-radius: 6px;
    border: none;
    background-color: #e01b3c;
    color: white;
    font-weight: 600;
    cursor: pointer;
  }
}
</style>
