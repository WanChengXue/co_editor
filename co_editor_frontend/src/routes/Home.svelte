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

  function newDocButtonClick(event) {
    event.preventDefault();
    console.log("new doc clicked!");
  }

  function editButtonClick(event, doc) {
    event.preventDefault();
    console.log(`Edit clicked for ${doc.doc_room}`);
    location.href = `/#/doc/${doc.id}/${doc.doc_name}/${doc.doc_room}`;
  }

  async function fetchData() {
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
    ydoc = new Y.Doc();
    // sha256("niubi")
    provider = new WebrtcProvider(
      "9a1c2b0b42196c3e24ca742593e26b29221915adc239fb158ebb4cd43d0b32c1",
      ydoc,
    );
    docData = [];
    mapDB = ydoc.getMap("mapDB");
    const user1 = new Doc(1, "John Doe", "john@example.com");
    mapDB.set("2", JSON.stringify(user1));
    mapDB.forEach((value, id, mapDB) => {
      const elementDoc = JSON.parse(value);
      docData.push(elementDoc);
    });
    // fetchData();
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
              <div class="row row-cards">
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
                              ><a
                                href="#"
                                class="btn btn-ghost-primary w-100"
                                on:click={newDocButtonClick}
                              >
                                New Doc
                              </a></th
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
          </div>
        </div>
      </div>
      <script src="/dist/js/tabler.js"></script>
    </body></html
  >
</main>
