<template>
  <div class="login-page">
    <div class="login-container">
      <UiPageHeader title="Welcome Back" subtitle="Please login to your account" />
      
      <UiCard>
        <div class="login-form">
          <div class="field">
            <label for="email">E-mail</label>
            <input id="email" type="email" v-model="email" placeholder="Enter your email">
          </div>

          <div class="field">
            <label for="password">Password</label>
            <input id="password" type="password" v-model="password" @keyup.enter="makeLogin" placeholder="Enter your password">
          </div>

          <div class="actions">
            <button class="btn btn-full" @click="makeLogin">Login</button>
          </div>

          <div class="error-msg" v-if="error">
            {{ error }}
          </div>
        </div>
      </UiCard>
    </div>
  </div>
</template>

<script>
import { AuthService } from '@/services/auth.service'
import UiPageHeader from '@/components/UiPageHeader.vue'
import UiCard from '@/components/UiCard.vue'

export default {
  name: 'Login',
  components: {
    UiPageHeader,
    UiCard
  },
  data () {
    return {
      email: 'user@user.com',
      password: '123456',
      error: ''
    }
  },

  methods: {
    async makeLogin () {
      try {
        await AuthService.makeLogin({ email: this.email, password: this.password })
        this.error = ''
        await this.$store.dispatch('user/getCurrent')
        await this.$router.push('profile')
      } catch (error) {
        this.$store.commit('toast/NEW', { type: 'error', message: error.message })
        this.error = error.status === 404 ? 'User with same email not found' : error.message
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.login-page {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 60vh;
  
  .login-container {
    width: 100%;
    max-width: 440px;
  }

  .login-form {
    padding: 10px 0;
  }

  .btn-full {
    width: 100%;
  }

  .error-msg {
    margin-top: 20px;
    padding: 12px;
    background-color: rgba(#e01b3c, 0.1);
    color: #e01b3c;
    border-radius: 6px;
    font-size: 14px;
    text-align: center;
  }
}
</style>
