import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
  },

  disconnected() {
  },

  received(data) {
    const badge = document.getElementById("notification-badge")

    if (!badge) return

    const currentCount = parseInt(badge.textContent, 10) || 0
    badge.textContent = currentCount + 1
    badge.style.display = "inline-block"
  }
})