<script>
  import { onDestroy, onMount } from "svelte";

  import * as Y from "yjs";
  import { WebrtcProvider } from "y-webrtc";
  import { QuillBinding } from "y-quill";
  import Quill from "quill";
  import QuillCursors from "quill-cursors";
  import "quill/dist/quill.snow.css";
  import axios from "axios";
  import FormData from "form-data";
  import repl_svg from "../lib/ui/accenture.svg";

  // 使用 cursors 插件
  Quill.register("modules/cursors", QuillCursors);

  let quill;
  let binding;
  let provider;
  export let params = {};
  let id = params.id;
  let docname = params.docname;
  let docroom = params.docroom;
  let editorElement; // 编辑器容器元素
  let ydoc;
  let type;

  async function replRequest(doccontent) {
    try {
      const data = {
        user_id: "1",
        doc_id: id,
        doc_content: doccontent,
      };

      const response = await axios.post(
        "http://localhost:4000/api/rich_text/ai",
        data,
        {
          timeout: 0,
        }
      );

      const content = response.data.replace(/\n/g, "<br>");
      console.log(content)
      return content; // 返回 response.data[0] 或根据需要返回 response
    } catch (error) {
      if (axios.isCancel(error)) {
        console.log("request cancelled");
      } else if (error.code === 'ECONNABORTED') {
        console.log("request timeout");
      } else {
        console.log("error: " , error.message);
      }
    }
  }

  async function leavePageHandler() {
    var data = new FormData();
    data.append("docname", docname);
    data.append("docroom", docroom);
    data.append("doccontent", quill.getText());

    var config = {
      method: "patch",
      url: "http://localhost:4000/api/item/" + id,
      headers: {
        Accept: "*/*",
      },
      data: data,
    };

    axios(config)
      .then(function (response) {
        console.log(JSON.stringify(response.data));
      })
      .catch(function (error) {
        console.log(error);
      });
  }

  function nodeLeave() {
    //离开当前页面等于当前节点从网络中离线, 在该时间点, 后端对doc进行一次快照
    if (quill) {
      // 后端保存doc content
      leavePageHandler();
      // 销毁 ydoc、provider
      binding.destroy();
      provider.disconnect();
      ydoc.destroy();
      quill.disable();
      quill = null; // 重置 quill 变量
    }
  }
  // masterRoom : {{id: doc.id, doc_room: doc_room}}
  onMount(() => {
    //  TODO: webrtc广播后 ，若当前网络仅有当前节点，则 doc_content 为最新数据
    ydoc = new Y.Doc();
    provider = new WebrtcProvider(docroom, ydoc);
    type = ydoc.getText("quill");

    const TOOLBAR_CONFIG = [
      [{ header: ["1", "2", "3", false] }],
      ["bold", "italic", "underline", "link"],
      ["repl"], // repl button
    ];

    // @ts-ignore
    const icons = Quill.import("ui/icons");
    icons["repl"] =
      '<svg data-slot="icon" fill="none" stroke-width="1.5" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5"></path></svg>';

    // @ts-ignore
    quill = new Quill(editorElement, {
      modules: {
        cursors: true,
        toolbar: {
          container: TOOLBAR_CONFIG,
          handlers: {
            async repl() {
              try {
                const text = await replRequest(quill.getText());
                const delta = quill.clipboard.convert(text);
                quill.setContents(delta, "silent");
                // 让Quill编辑器重新渲染内容
              } catch (error) {
                console.log("request error:", error);
              }
            },
          },
        },
        history: {
          userOnly: true, // 用户自己实现历史记录
        },
      },
      placeholder: "input...",
      theme: "snow",
    });

    binding = new QuillBinding(type, quill, provider.awareness);

    // All of our network providers implement the awareness crdt
    // const awareness = provider.awareness;

    // awareness.on("change", (changes) => {
    //   const states = Array.from(awareness.getStates().values());
    //   replRequest(quill.getText());
    // });

    // // You can think of your own awareness information as a key-value store.
    // // We update our "user" field to propagate relevant user information.
    // awareness.setLocalStateField("user", {
    //   // Define a print name that should be displayed
    //   name: "Emmanuelle Charpentier",
    //   // Define a color that should be associated to the user:
    //   color: "#ffb61e", // should be a hex color
    // });
  });

  onDestroy(() => {
    nodeLeave();
  });
</script>

<main>
  <div bind:this={editorElement}></div>
</main>
