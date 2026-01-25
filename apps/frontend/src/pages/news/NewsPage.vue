<template>
  <div class="news-page-container">
    <div class="header-section">
      <h1>EzOps News</h1>
      <p class="subtitle">Stay updated with the latest in Cloud & DevOps</p>
    </div>

    <div class="news-list">
      <DataBox :loading="loading" :isEmpty="isEmpty" :error="error">
        <div class="news-card" v-for="item in news" :key="item.id">
          <div class="card-header">
            <h2>{{item.title}}</h2>
            <!-- Date could be added here if available -->
          </div>
          <div class="card-body">
            <div class="news-content" v-html="item.content"></div>
          </div>
        </div>
      </DataBox>
    </div>
  </div>
</template>

<script>
import { PostsService } from '@/services/posts.service'
import prepareQueryParamsMixin from '../../mixins/prepareQueryParamsMixin'
import prepareFetchParamsMixin from '../../mixins/prepareFetchParamsMixin'
import DataBox from '../../components/DataBox'

export default {
  name: 'NewsPage',
  mixins: [prepareQueryParamsMixin, prepareFetchParamsMixin],
  components: {
    DataBox
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
.news-page-container {
  max-width: 900px;
  margin: 0 auto;
  padding: 40px 20px;
  background-color: #f8f9fa;
  min-height: 100vh;
}

.header-section {
  text-align: center;
  margin-bottom: 50px;

  h1 {
    font-size: 3rem;
    color: #2c3e50;
    margin-bottom: 10px;
    font-weight: 700;
  }

  .subtitle {
    font-size: 1.2rem;
    color: #7f8c8d;
    font-weight: 300;
  }
}

.news-card {
  background: #ffffff;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
  margin-bottom: 40px;
  overflow: hidden;
  transition: transform 0.2s ease, box-shadow 0.2s ease;

  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
  }

  .card-header {
    padding: 30px 40px 10px 40px;
    
    h2 {
      font-size: 2rem;
      color: #34495e;
      margin: 0;
      line-height: 1.3;
    }
  }

  .card-body {
    padding: 10px 40px 40px 40px;
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

@media (max-width: 768px) {
  .news-page-container {
    padding: 20px 15px;
  }
  
  .news-card {
    .card-header, .card-body {
      padding: 20px;
    }

    h2 {
      font-size: 1.5rem;
    }
  }
}
</style>
