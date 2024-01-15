<script>
  import { onDestroy, onMount } from "svelte";

  import * as Y from "yjs";
  import { WebrtcProvider, Room } from "y-webrtc";
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
      return content; // 返回 response.data[0] 或根据需要返回 response
    } catch (error) {
      if (axios.isCancel(error)) {
        console.log("request cancelled");
      } else if (error.code === "ECONNABORTED") {
        console.log("request timeout");
      } else {
        console.log("error: ", error.message);
      }
    }
  }

  async function saveHandler() {
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

  function handleBeforeUnload(event) {
    // 使用默认的浏览器弹窗文本
    // event.preventDefault();
  }

  // masterRoom : {{id: doc.id, doc_room: doc_room}}
  onMount(() => {
    // 在组件挂载时添加事件监听器
    window.addEventListener("beforeunload", handleBeforeUnload);

    //  TODO: webrtc广播后 ，若当前网络仅有当前节点，则 doc_content 为最新数据
    ydoc = new Y.Doc();
    provider = new WebrtcProvider(docroom, ydoc);
    type = ydoc.getText("quill");

    const TOOLBAR_CONFIG = [
      [{ header: ["1", "2", "3", false] }],
      ["bold", "italic", "underline", "link"],
      ["repl"], // repl button
      ["save"], // save button
    ];

    // @ts-ignore
    const icons = Quill.import("ui/icons");
    icons["repl"] =
      '<svg data-slot="icon" fill="none" stroke-width="1.5" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5"></path></svg>';
    icons["save"] =
    '<?xml version="1.0" encoding="UTF-8" standalone="no"?> <svg xmlns="http://www.w3.org/2000/svg" data-name="Layer 1" viewBox="0 0 64 64"><path fill="none" stroke="#010101" stroke-miterlimit="10" stroke-width="4" d="M58,58H12L6,52V8A2,2,0,0,1,8,6H56a2,2,0,0,1,2,2Z"/><rect width="36" height="24" x="14" y="6" fill="none" stroke="#010101" stroke-miterlimit="10" stroke-width="4"/><rect width="24" height="16" x="18" y="42" fill="none" stroke="#010101" stroke-miterlimit="10" stroke-width="4"/><line x1="26" x2="26" y1="48" y2="58" fill="none" stroke="#010101" stroke-miterlimit="10" stroke-width="4"/></svg>';
    
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
            async save(){
              try {
                saveHandler();
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

    // 如果没人在房间里，则quill内容为空，从后端获取doc content
    // 有人在房间里，则quill内容不为空，无需获取doc content
    load_doc();

    return () => {
      // 在组件销毁时移除事件监听器
      window.removeEventListener("beforeunload", handleBeforeUnload);
    };
  });

  function load_doc() {
    const text = quill.getText();
    get_doc_content();
    if (text.size > 0) {
      // new doc content in quill
    } else {
      // new doc content in DB
      get_doc_content();
    }
  }

  function get_doc_content() {
    axios
      .get("http://localhost:4000/api/item/" + id)
      .then(function (response) {
        quill.setText(response["data"]["doc_content"]);
      })
      .catch(function (error) {
        console.log(error);
      });
  }
</script>

<main>
  <div bind:this={editorElement}></div>
</main>
