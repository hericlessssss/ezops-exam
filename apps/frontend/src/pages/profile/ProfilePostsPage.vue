<template>
  <div class="profile-posts">
    <DataBox :loading="loading" :isEmpty="isEmpty" :error="error" @retry="fetchData">
      <div class="posts-grid">
        <UiCard v-for="item in posts" :key="item.id">
          <div class="post-item">
            <h3 class="post-title">{{item.title}}</h3>
            <div class="post-actions">
              <button class="btn btn-secondary btn-sm">View</button>
              <button class="btn btn-secondary btn-sm">Edit</button>
            </div>
          </div>
        </UiCard>
      </div>
    </DataBox>
  </div>
</template>

<script>
import { PostsService } from '@/services/posts.service'
import prepareQueryParamsMixin from '../../mixins/prepareQueryParamsMixin'
import prepareFetchParamsMixin from '../../mixins/prepareFetchParamsMixin'
import DataBox from '../../components/DataBox'
import UiCard from '@/components/UiCard.vue'

export default {
  name: 'ProfilePostsPage',
  components: {
    DataBox,
    UiCard
  },

  props: {
    limit: { type: Number, default: 10 },
    offset: { type: Number, default: 0 }
  },

  mixins: [prepareQueryParamsMixin, prepareFetchParamsMixin],

  watch: {
    'pagination.limit': function () {
      this.$router.replace({
        query: this.useInUrlQueryPropList
      })
      this.fetchData()
    },
    'pagination.offset': function () {
      this.$router.replace({
        query: this.useInUrlQueryPropList
      })
      this.fetchData()
    }
  },

  data () {
    return {
      posts: [],
      error: false,
      loading: false,
      pagination: {
        limit: this.limit,
        offset: this.offset,
        total: 0
      }
    }
  },

  methods: {
    async fetchData () {
      this.loading = true

      try {
        const { data } = await PostsService.getPostsByUserId(this.fetchParams)
        this.posts = data.content
        this.pagination.total = data.total
      } catch (e) {
        this.$store.commit('toast/NEW', { type: 'error', message: e.message, e })
        this.error = e.message
        console.log(e)
      } finally {
        this.loading = false
      }
    }
  },

  computed: {
    filter () {
      return {
        userId: this.$currentUser.id
      }
    },
    useInUrlQueryPropList () {
      return this.prepareQueryParamsMixin({
        limit: this.pagination.limit,
        offset: this.pagination.offset
      })
    },
    fetchParams () {
      const filter = this.prepareFetchParamsMixin(this.filter)

      const pagination = this.prepareFetchParamsMixin({
        limit: this.pagination.limit,
        offset: this.pagination.offset
      })

      return { filter, ...pagination }
    },
    isEmpty () {
      return this.posts && !this.posts.length
    }
  },

  mounted () {
    this.fetchData()
  }
}
</script>
