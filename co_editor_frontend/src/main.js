import * as Y from 'yjs'
import { WebrtcProvider } from 'y-webrtc'
import { QuillBinding } from 'y-quill'
import Quill from 'quill'
import QuillCursors from 'quill-cursors'
import 'quill/dist/quill.snow.css'; // 使用了 snow 主题色

// 使用 cursors 插件
Quill.register('modules/cursors', QuillCursors);

const quill = new Quill(document.querySelector('#app'), {
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

// A Yjs document holds the shared data
const ydoc = new Y.Doc()

const provider = new WebrtcProvider('quill-demo-room', ydoc)

// Define a shared text type on the document
const ytext = ydoc.getText('quill')

// "Bind" the quill editor to a Yjs text type.
const binding = new QuillBinding(ytext, quill, provider.awareness)
