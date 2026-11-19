const { Plugin } = require('obsidian');

module.exports = class extends Plugin {
  onload() {
    if (process.platform !== 'darwin') return;
    this.app.workspace.onLayoutReady(() => {
      // После первого обновления оформления окна при запуске Obsidian.
      const timer = window.setTimeout(() => {
        document.body.classList.add('kn-transparent');
        window.electronWindow.setVibrancy(null);
        window.electronWindow.setBackgroundColor('#00000000');
        this.app.workspace.trigger('css-change');
      }, 0);
      this.register(() => window.clearTimeout(timer));
    });
  }

  onunload() {
    document.body.classList.remove('kn-transparent');
    this.app.workspace.trigger('css-change');
  }
};
