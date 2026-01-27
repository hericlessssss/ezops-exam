<template>
  <div id="app">
    <AppHeader />
    <main class="main-content">
      <div class="wrapper">
        <transition name="fade" mode="out-in">
          <router-view></router-view>
        </transition>
      </div>
    </main>
    <AppFooter />
  </div>

</template>

<script>
import AppHeader from './Header.vue'
import AppFooter from './Footer.vue'

export default {
  name: 'AppLayout',
  components: {
    AppHeader,
    AppFooter
  }
}
</script>s
