<script>
  import { onMount } from 'svelte';

  import * as Y from 'yjs';
  import { WebrtcProvider } from 'y-webrtc';
  import { QuillBinding } from 'y-quill';
  import Quill from 'quill';
  import QuillCursors from 'quill-cursors';
  import 'quill/dist/quill.snow.css';

  // 使用 cursors 插件
  Quill.register('modules/cursors', QuillCursors);

  let quill;

  async function sendPostRequest(data) {
    try {
      console.log(data);
      const response = await fetch('http://127.0.0.1:4000', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
      });

      if (response.ok) {
        console.log('POST request successful');
      } else {
        console.log('POST request failed');
      }
    } catch (error) {
      console.error('Error sending POST request:', error);
    }
  }

  onMount(() => {
    const ydoc = new Y.Doc();
    const provider = new WebrtcProvider('co_editor', ydoc);
    const type = ydoc.getText('quill');

    // @ts-ignore
    quill = new Quill(document.querySelector('#app'), {
      modules: {
        cursors: true,
        toolbar: [
          [{ header: [1, 2, false] }],
          ['bold', 'italic', 'underline'],
          ['image', 'code-block'],
        ],
        history: {
          userOnly: true, // 用户自己实现历史记录
        },
      },
      placeholder: 'input...',
      theme: 'snow',
    });

    const binding = new QuillBinding(type, quill, provider.awareness);

    // All of our network providers implement the awareness crdt
    const awareness = provider.awareness

    // You can observe when a user updates their awareness information
    awareness.on('change', changes => {
      // Whenever somebody updates their awareness information,
      // we log all awareness information from all users.
      const states = Array.from(awareness.getStates().values());
      sendPostRequest(quill.getText());
    })

    // You can think of your own awareness information as a key-value store.
    // We update our "user" field to propagate relevant user information.
    awareness.setLocalStateField('user', {
      // Define a print name that should be displayed
      name: 'Emmanuelle Charpentier',
      // Define a color that should be associated to the user:
      color: '#ffb61e' // should be a hex color
    })
  });
  
</script>

<div id="app"></div>

