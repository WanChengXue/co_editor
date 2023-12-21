<script>
    import { onMount } from 'svelte';
  
    import * as Y from 'yjs';
    import { WebrtcProvider } from 'y-webrtc';
    import { QuillBinding } from 'y-quill';
    import Quill from 'quill';
    import QuillCursors from 'quill-cursors';
    import 'quill/dist/quill.snow.css';
    import axios from "axios";
  
    // 使用 cursors 插件
    Quill.register('modules/cursors', QuillCursors);
  
    let quill;
    let doc_id;
    let doc_name;
    let doc_room;
  
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

    async function leavePageHandler() {
      try {
        const response = await axios.patch("http://localhost:4000/api/item/" + doc_id, {
          params: {
            docname: doc_name,
            docroom: doc_room,
            doccontent: quill.getText(),
          },
        });
      } catch (error) {
        console.error(error);
    }
  }
  
    onMount(() => {
      // svelte 默认哈希模式路由，需要去掉前置 #
      const urlParams = new URLSearchParams(window.location.hash.substr(1));
      doc_id = urlParams.get('id');
      doc_name = urlParams.get('docname');
      doc_room = urlParams.get('roomname');
      //  TODO: webrtc广播后 ，若当前网络仅有当前节点，则 doc_content 为最新数据

      const ydoc = new Y.Doc();
      const provider = new WebrtcProvider(doc_room, ydoc);
      console.log(doc_room)
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
        // sendPostRequest(quill.getText());
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
    
    import { onDestroy } from 'svelte';

    function cleanup() {
      // TODO: 当用户导航到新页面或关闭当前页面时，浏览器会中止当前页面上的所有网络请求, 因此leavePageHandler无法保证被执行
      // 需要重新考虑 doc更新的策略
      leavePageHandler();
      location.reload();
    }

    onDestroy(cleanup);
  </script>
  
<div id="app"></div>
  
  