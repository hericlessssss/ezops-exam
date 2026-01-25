<template>
  <div class="hello page">
    <div style="text-align: center; margin-top: 50px;">
      <h1>Hello World!</h1>
      <br>
      <p style="font-size: 18px; color: #666;">
        Welcome to the Hello page. This is a new feature added to the EzOps application.
      </p>
      <br>
      <img src="https://i.imgur.com/vUtatQS.jpeg" style="max-width: 600px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
    </div>
  </div>
</template>

<script>
export default {
  name: 'HelloPage',
  metaInfo: {
    title: 'Hello'
  }
}
</script>

<style scoped>
.hello {
  padding: 20px;
}
</style>
