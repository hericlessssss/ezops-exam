<template>
  <div class="news-page">
    <UiPageHeader title="EzOps News" subtitle="Stay updated with the latest in Cloud & DevOps" />

    <div class="news-list">
      <DataBox :loading="loading" :isEmpty="isEmpty" :error="error" @retry="fetchData">
        <UiCard v-for="item in news" :key="item.id">
          <template #header>
            <h2 class="news-title">{{item.title}}</h2>
          </template>
          <div class="news-content" v-html="item.content"></div>
        </UiCard>
      </DataBox>
    </div>
  </div>
</template>

<script>
import { PostsService } from '@/services/posts.service'
import prepareQueryParamsMixin from '../../mixins/prepareQueryParamsMixin'
import prepareFetchParamsMixin from '../../mixins/prepareFetchParamsMixin'
import DataBox from '../../components/DataBox'
import UiPageHeader from '@/components/UiPageHeader.vue'
import UiCard from '@/components/UiCard.vue'

export default {
  name: 'NewsPage',
  mixins: [prepareQueryParamsMixin, prepareFetchParamsMixin],
  components: {
    DataBox,
    UiPageHeader,
    UiCard
  },
  props: {
    limit: { type: Number, default: 10 },
    offset: { type: Number, default: 0 }
  },
  watch: {
    'pagination.limit': function () {
      this.$router.replace({ query: this.useInUrlQueryPropList })
      this.fetchData()
    },
    'pagination.offset': function () {
      this.$router.replace({ query: this.useInUrlQueryPropList })
      this.fetchData()
    }
  },
  data () {
    return {
      news: [],
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
        const { data } = await PostsService.getListPublic(this.fetchParams)
        this.news = data.content
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
    isEmpty () {
      return this.news && !this.news.length
    },
    useInUrlQueryPropList () {
      return this.prepareQueryParamsMixin({
        limit: this.pagination.limit,
        offset: this.pagination.offset
      })
    },
    fetchParams () {
      return {
        ...this.prepareFetchParamsMixin({
          limit: this.pagination.limit,
          offset: this.pagination.offset
        })
      }
    }
  },
  created () {
    this.fetchData()
  }
}
</script>

<style lang="scss" scoped>
.news-page {
  .news-list {
    margin-top: 20px;
  }

  .news-title {
    font-size: 24px;
    color: #333;
    margin: 0;
  }
}

/* Deep Selector for Dynamic HTML Content */
.news-content ::v-deep {
  font-size: 1.1rem;
  line-height: 1.8;
  color: #555;

  p {
    margin-bottom: 20px;
  }

  img {
    display: block;
    margin: 30px auto;
    max-width: 100%;
    max-height: 500px; /* Limits height to avoid huge images */
    object-fit: cover; /* Ensures image covers area or containment */
    border-radius: 8px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
  }
}
</style>
