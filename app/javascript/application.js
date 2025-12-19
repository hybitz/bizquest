import { createApp } from 'vue'
import App from './app.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = createApp(App)
  const container = document.createElement('div')
  app.mount(container)
  document.body.appendChild(container)
})
