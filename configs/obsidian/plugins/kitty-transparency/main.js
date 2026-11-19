const { Plugin } = require('obsidian');

module.exports = class extends Plugin {
  onload() {
    if (process.platform !== 'darwin') return;

    let active = true;
    let timer;
    this.register(() => {
      active = false;
      window.clearTimeout(timer);
    });

    this.app.workspace.onLayoutReady(() => {
      if (!active) return;

      timer = window.setTimeout(() => {
        const electronWindow = window.electronWindow;
        if (
          typeof electronWindow?.getBackgroundColor !== 'function' ||
          typeof electronWindow?.setBackgroundColor !== 'function'
        ) return;

        try {
          const originalColor = electronWindow.getBackgroundColor();
          if (typeof originalColor !== 'string' || !originalColor) return;

          electronWindow.setBackgroundColor('#00000000');
          this.restoreBackground = () => electronWindow.setBackgroundColor(originalColor);
          document.body.classList.add('kn-transparent');
          this.app.workspace.trigger('css-change');
        } catch {
          console.warn('Kitty Transparency could not apply the window effect.');
        }
      }, 0);
    });
  }

  onunload() {
    if (!this.restoreBackground) return;

    try {
      this.restoreBackground();
    } catch {
      console.warn('Kitty Transparency could not restore the window background.');
    } finally {
      this.restoreBackground = undefined;
      document.body.classList.remove('kn-transparent');
      this.app.workspace.trigger('css-change');
    }
  }
};
