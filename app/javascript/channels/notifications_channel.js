import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    console.log("NotificationsChannelに接続しました")
  },

  disconnected() {
    console.log("NotificationsChannelから切断されました")
  },

  received(data) {
    console.log(data)

    const badge = document.getElementById("notification-badge")

    if (!badge) return

    const currentCount = parseInt(badge.textContent, 10) || 0
    badge.textContent = currentCount + 1
    badge.style.display = "inline-block"
  }
});