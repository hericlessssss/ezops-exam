const request = require('supertest')
const app = require('../server')
const postsService = require('../service/postsService')

// Mock the Service Loop
jest.mock('../service/postsService')
jest.mock('../service/migrationService', () => ({
  runMigrations: jest.fn().mockResolvedValue()
}))
// (We do not mock database anymore as it shouldn't be reached if Service is mocked)
// Actually server.js imports migrationService.

describe('Posts API', () => {
  beforeEach(() => {
    jest.clearAllMocks()
  })

  test('Should get posts', async () => {
    const mockPosts = [
      { id: 1, title: 'T1', content: 'C1' },
      { id: 2, title: 'T2', content: 'C2' },
      { id: 3, title: 'T3', content: 'C3' }
    ]
    postsService.getPosts.mockResolvedValue(mockPosts)

    const response = await request(app).get('/posts')
    expect(response.status).toBe(200)
    expect(response.body.data).toHaveLength(3) // postsRoute wraps in { data: ... }
  })

  test('Should save a post', async () => {
    const newPost = { title: 'New', content: 'Content' }
    postsService.savePost.mockResolvedValue({ id: 1, ...newPost })

    const response = await request(app).post('/posts').send(newPost)
    expect(response.status).toBe(201)
    expect(response.body.title).toBe(newPost.title)
  })

  test('Should handle save error (Conflict)', async () => {
    postsService.savePost.mockRejectedValue(new Error('Post already exists'))

    const newPost = { title: 'Duplicate', content: 'Content' }
    const response = await request(app).post('/posts').send(newPost)
    expect(response.status).toBe(409)
  })

  test('Should update a post', async () => {
    postsService.updatePost.mockResolvedValue()

    const response = await request(app).put('/posts/123').send({ title: 'U', content: 'C' })
    expect(response.status).toBe(204)
  })

  test('Should not update non-existent post (Service throws)', async () => {
    // Service.updatePost throws 'Post not found' if logic checks it
    postsService.updatePost.mockRejectedValue(new Error('Post not found'))

    const response = await request(app).put('/posts/999').send({ title: 'A', content: 'B' })
    expect(response.status).toBe(404)
  })

  test('Should delete a post', async () => {
    postsService.deletePost.mockResolvedValue()

    const response = await request(app).delete('/posts/1')
    expect(response.status).toBe(204)
  })
})
