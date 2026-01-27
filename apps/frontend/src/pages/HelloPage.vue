<template>
  <div class="hello-page">
    <UiPageHeader
      title="Hello World!"
      subtitle="Welcome to the Hello page. This is a new feature added to the EzOps application."
    />
    
    <UiCard>
      <div class="image-container">
        <img src="https://i.imgur.com/vUtatQS.jpeg" alt="Hello Image">
      </div>
    </UiCard>
  </div>
</template>

<script>
import UiPageHeader from '@/components/UiPageHeader.vue'
import UiCard from '@/components/UiCard.vue'

export default {
  name: 'HelloPage',
  components: {
    UiPageHeader,
    UiCard
  },
  metaInfo: {
    title: 'Hello'
  }
}
</script>

<style lang="scss" scoped>
.hello-page {
  .image-container {
    display: flex;
    justify-content: center;
    
    img {
      max-width: 100%;
      height: auto;
      border-radius: 4px;
    }
  }
}
</style>
