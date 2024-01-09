<script>
  import { onDestroy, onMount } from "svelte";
  import { SHA256 } from "crypto-js";

  import * as Y from "yjs";
  import { WebrtcProvider } from "y-webrtc";
  import { QuillBinding } from "y-quill";
  import Quill from "quill";
  import QuillCursors from "quill-cursors";
  import "quill/dist/quill.snow.css";
  import axios from "axios";
  import FormData from "form-data";

  let docData = []; // 将 docData 声明为组件的 props
  let ydoc;
  let provider;
  let type;
  let mapDB;

  class Doc {
    constructor(id, doc_name, doc_room) {
      this.id = id;
      this.doc_name = doc_name;
      this.doc_room = doc_room;
    }

    toDict() {
      const resultDict = {};
      // 遍历用户对象的属性，并将其添加到字典中
      for (let key in this) {
        this[key] = this[key];
      }
      return resultDict;
    }
  }

  function editButtonClick(event, doc) {
    event.preventDefault();
    console.log(`Edit clicked for ${doc.doc_room}`);
    location.href = `/#/doc/${doc.id}/${doc.doc_name}/${doc.doc_room}`;
  }

  function saveDocButtonClick(event) {
    var inputElement = document.getElementById("docname");
    // @ts-ignore
    var docName = inputElement.value;

    // TODO: save to DB
    newDocRequest(docName);
    // TODO: P2P 存储 doc list
    // let tmpDocData = [];
    // mapDB = ydoc.getMap("mapDB");
    // const docObject = new Doc(mapDB.size, docName, "john@example.com");
    // mapDB.set(mapDB.size, JSON.stringify(docObject));
    // // 本地修改
    // mapDB.forEach((value, id, mapDB) => {
    //   console.log(value);
    //   const elementDoc = JSON.parse(value);
    //   tmpDocData.push(elementDoc);
    // });
    // // 广播修改
    // ydoc.transact(() => {
    //   mapDB.set(mapDB.size, JSON.stringify(docObject));
    // });
    // docData = tmpDocData;
  }

  async function newDocRequest(docName) {
    // 新建文档请求
    const data = {
      docname: docName,
      docroom: SHA256(docName).toString(),
    };
    await axios
      .post("http://localhost:4000/api/item", data)
      .then((response) => {
        // TODO: 仅仅获取最新一个item而不是整个列表
        fetchDocListRequest();
      })
      .catch((error) => {
        console.error(error);
      });
  }

  async function fetchDocListRequest() {
    // 获取文档列表请求
    try {
      const response = await axios.get("http://localhost:4000/api/item", {
        params: {
          username: "your_username",
          token: "your_token",
        },
      });
      docData = response.data.data; // 更新组件的 props
    } catch (error) {
      console.error(error);
    }
  }

  onMount(() => {
    fetchDocListRequest();

    // TODO: P2P 存储 doc list
    // ydoc = new Y.Doc();
    // // sha256("niubi")
    // provider = new WebrtcProvider(
    //   "9a1c2b0b42196c3e24ca742593e26b29221915adc239fb158ebb4cd43d0b32c1",
    //   ydoc,
    // );
    // {
    // docData = [];
    // mapDB = ydoc.getMap("mapDB");
    // const docObject = new Doc(0, "John Doe", "john@example.com");
    // mapDB.set("1", JSON.stringify(docObject));
    // mapDB.forEach((value, id, mapDB) => {
    //   console.log(value);
    //   const elementDoc = JSON.parse(value);
    //   docData.push(elementDoc);
    // });

    // All of our network providers implement the awareness crdt
    // const awareness = provider.awareness;

    // You can observe when a user updates their awareness information
    // awareness.on("change", (changes) => {
    //   // mapDB = ydoc.getMap("mapDB");
    //   // const docObject = new Doc(0, "John Doe", "john@example.com");
    //   // mapDB.set("1", JSON.stringify(docObject));
    //   // mapDB.forEach((value, id, mapDB) => {
    //   //   console.log(value);
    //   //   const elementDoc = JSON.parse(value);
    //   //   docData.push(elementDoc);
    //   // });
    //   // console.log("change");
    // });

    // }
  });
</script>

<main>
  <html lang="en"
    ><head>
      <link rel="stylesheet" href="/dist/css/tabler.css" />
    </head>
    <body>
      <script src="./dist/js/demo-theme.min.js?1695847769"></script>
      <div class="page">
        <div class="page-wrapper">
          <!-- Page header -->
          <div class="page-header d-print-none">
            <div class="container-xl">
              <div class="row g-2 align-items-center">
                <div class="col">
                  <h2 class="page-title">doc list</h2>
                </div>
              </div>
            </div>
          </div>
          <!-- Page body -->
          <div class="page-body">
            <div class="container-xl">
              <div id="doclist" class="row row-cards">
                <div class="col-12">
                  <div class="card">
                    <div class="table-responsive">
                      <table
                        class="table table-vcenter card-table table-striped"
                      >
                        <thead>
                          <tr>
                            <th>doc</th>
                            <th class="w-1"
                              ><button
                                type="button"
                                class="btn btn-primary"
                                data-bs-toggle="modal"
                                data-bs-target="#exampleModal"
                              >
                                New Doc
                              </button></th
                            >
                          </tr>
                        </thead>
                        <tbody>
                          {#each docData as doc}
                            <tr>
                              <td>{doc.doc_name}</td>
                              <td>
                                <a
                                  href="#"
                                  on:click={(event) =>
                                    editButtonClick(event, doc)}>Edit</a
                                >
                              </td>
                            </tr>
                          {/each}
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="modal" id="exampleModal" tabindex="-1">
              <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title">New Doc</h5>
                    <button
                      type="button"
                      class="btn-close"
                      data-bs-dismiss="modal"
                      aria-label="Close"
                    ></button>
                  </div>
                  <div class="modal-body">
                    <div class="mb-3">
                      <label class="form-label">Doc Name</label>
                      <input
                        id="docname"
                        type="text"
                        class="form-control"
                        name="example-text-input"
                        placeholder="Your doc name"
                      />
                    </div>
                  </div>
                  <div class="modal-footer">
                    <a
                      href="#"
                      class="btn btn-link link-secondary"
                      data-bs-dismiss="modal"
                    >
                      Cancel
                    </a>
                    <a
                      href="#"
                      on:click={(event) => saveDocButtonClick(event)}
                      class="btn btn-primary ms-auto"
                      data-bs-dismiss="modal"
                    >
                      Create
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <script src="/dist/js/tabler.js"></script>
    </body></html
  >
</main>
