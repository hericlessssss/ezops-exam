<template>
  <div class="home-page">
    <UiPageHeader title="Welcome to Index!!!" subtitle="Explore our components and features" />

    <UiCard title="Interactive Elements">
      <div class="buttons-row">
        <button class="btn" @click="isShownModal = true">show modal</button>
        <button class="btn btn-secondary" @click="showToast">show toast</button>
      </div>

      <UiModal closeOnOverlay :show.sync="isShownModal">
        <div class="some-modal-content">
          <h3>Modal Example</h3>
          <p>This is a standardized modal content area.</p>
          <div class="buttons">
            <button class="btn" @click="submitModalHandler">ok</button>
          </div>
        </div>
      </UiModal>

      <div class="icon-section">
        <UiBaseIcon width="40px" height="40px" color="#e01b3c" iconName="done" @click="onClickIcon"/>
      </div>
    </UiCard>

    <UiCard title="Form Controls">
      <UiInputText
        v-model="msg"
        placeholder="Enter message"
        label="Message Input"
        @blur="onBlur"
        @keyup.enter="onEnter"
        @keyup.esc="onEsc"
        :error="inputError">
        <div slot="bottom">This is a very important description helper text.</div>
      </UiInputText>

      <div class="checkbox-section">
        <UiCheckbox label="Accept Terms" v-model="checkboxState"/>
      </div>
    </UiCard>

    <UiCard title="Navigation Controls">
      <UiPaginationOffset :offset.sync="pagination.offset" :limit="pagination.limit" :total="pagination.total"/>
    </UiCard>
  </div>
</template>

<script>
import UiPageHeader from '@/components/UiPageHeader.vue'
import UiCard from '@/components/UiCard.vue'
import UiModal from '@/components/UiModal.vue'
import UiBaseIcon from '@/components/icons/UiBaseIcon.vue'
import UiInputText from '@/components/UiInputText.vue'
import UiCheckbox from '@/components/UiCheckbox.vue'
import UiPaginationOffset from '../components/UiPaginationOffset'

export default {
  name: 'IndexPage',

  components: {
    UiPageHeader,
    UiCard,
    UiModal,
    UiBaseIcon,
    UiInputText,
    UiCheckbox,
    UiPaginationOffset
  },

  data () {
    return {
      msg: 'Welcome to Index!!!',
      isShownModal: false,
      inputError: false,
      checkboxState: false,

      pagination: {
        limit: 20,
        offset: 0,
        total: 60
      }
    }
  },

  methods: {
    showToast () {
      console.log('aaa')
      this.$store.commit('toast/NEW', { type: 'success', message: 'hello' })
    },
    submitModalHandler () {
      // some logic
      this.isShownModal = false
    },
    onBlur () {
      console.log('onBlur!!!')
    },
    onEnter () {
      console.log('onEnter!!!')
    },
    onEsc () {
      console.log('onEsc!!!')
    },
    onClickIcon () {
      console.log('onClickIcon!!!!')
    }
  }
}
</script>

<style lang="scss" scoped>
.home-page {
  .buttons-row {
    display: flex;
    gap: 12px;
    margin-bottom: 24px;
  }

  .icon-section {
    margin-top: 24px;
  }

  .checkbox-section {
    margin-top: 20px;
  }

  .some-modal-content {
    padding: 24px;
    
    h3 {
      margin-top: 0;
    }
    
    .buttons {
      margin-top: 24px;
      display: flex;
      justify-content: flex-end;
    }
  }
}

// Button styles are now global in _global.scss
</style>
