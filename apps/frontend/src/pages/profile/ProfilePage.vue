<template>
  <div class="profile-page">
    <UiPageHeader :title="msg" subtitle="Manage your account and posts" />
    
    <div class="profile-content">
      <transition name="fade" mode="out-in">
        <router-view v-if="$currentUser.id"></router-view>
      </transition>
    </div>
  </div>
</template>

<script>
import UiPageHeader from '@/components/UiPageHeader.vue'

export default {
  name: 'ProfilePage',
  components: {
    UiPageHeader
  },
  data () {
    return {
      msg: 'Welcome to profile!!!'
    }
  }
}
</script>
