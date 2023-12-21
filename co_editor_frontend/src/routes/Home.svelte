<script>
  import { onMount } from "svelte";
  import axios from "axios";

  export let docData = []; // 将 docData 声明为组件的 props
  
  function newDocButtonClick(event) {
    event.preventDefault();
    console.log("new doc clicked!");
  }

  function editButtonClick(event, doc) {
    event.preventDefault();
    console.log(`Edit clicked for ${doc.doc_room}`);
    location.href = `/#/doc?id=${doc.id}&docname=${doc.doc_name}&roomname=${doc.doc_room}`;
    location.reload();
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
    fetchData();
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
                              ><a href="#" class="btn btn-ghost-primary w-100" on:click={newDocButtonClick}>
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
                                <a href="#" on:click={(event) => editButtonClick(event, doc)}>Edit</a>
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
