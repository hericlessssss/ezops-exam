<template>
  <div class="ui-header-dropdown-menu component">
    <UiBaseMenuDropdown>
      <ul>
        <li><router-link :to="{ name: 'login' }">login</router-link></li>
      </ul>
    </UiBaseMenuDropdown>
  </div>
</template>

<script>
import UiBaseMenuDropdown from './UiBaseMenuDropdown'

export default {
  name: 'UiHeaderDropdownMenu',
  components: { UiBaseMenuDropdown }
}
</script>
