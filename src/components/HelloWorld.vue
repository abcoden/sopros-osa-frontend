<template>
  <v-container class="fill-height">
    <v-responsive class="align-centerfill-height mx-auto" max-width="900">
      <v-row class="mb-5">
        <v-img class="mb-4 mt-4 " height="150" src="@/assets/01_SOPROS_sq.png" />
        <v-img class="mb-4 mt-4" height="150" src="@/assets/eu-logo.jpg" />
      </v-row>
      <div class="text-right">
        <v-btn @click="toggleTheme">Light / Dark Mode</v-btn>
      </div>
      <!-- src="@/assets/01_EN_Co-Funded_by_the_EU_NEG.png"  alternativ verwenden wenn man ein Logo als asset hat -->



      <div class="text-center">
        <h1 class="text-center text-h2 mt-16 font-weight-bold">Athlete Social Protection Check</h1>
        <div class="text-left mt-12">This Self-Assessment Tool was developed within the
          EU-funded Erasmus+ Project “Assessing, Evaluating and Implementing Athletes' Social Protection in Olympic
          Sports – <a target="_blank" href="https://www.dshs-koeln.de/iesf/sopros">SOPROS</a>".
        </div>
        <iframe class="mt-5" width="800" height="450" src="https://www.youtube.com/embed/4J18b-vmd84" frameborder="0"
          allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
        <div class="ml-3 mt-5 mb- text-subtitle-2 text-center">
          <v-btn class="ml-5" color="primary" variant="elevated"
            href="https://www.dshs-koeln.de/en/institute-of-european-sport-development-and-leisure-studies/research-projects/ongoing-projects/sopros/resources-on-social-protection/"
            @click="copyAnswerIdToClipboard" target="_blank">Learn more about Social Protection</v-btn>
        </div>
      </div>

      <div class="py-4" />

      <v-row>
        <v-col cols="12">
          <v-card class="py-4" color="surface-variant" append-icon="mdi-earth" rounded="lg" variant="outlined">

            <template #title>
              <h2 class="text-h5 font-weight-bold">Select country and language to start your Athlete Social Protection
                Check
              </h2>
            </template>
            <!-- <div class="text-center">
              <v-btn icon class="ml-3"><v-img width="25" src="@/assets/de.svg"></v-img></v-btn>
              <v-btn size="x-large" color="primary" icon class="ml-3"><v-img width="40"
                  src="@/assets/de.svg"></v-img></v-btn>
              <v-btn icon class="ml-3"><v-img width="50" src="@/assets/de.svg"></v-img></v-btn>
            </div> -->


            <v-select v-model="selected_country" :items="countries" item-title="name" item-value="id" label="Select"
              persistent-hint return-object single-line></v-select>
            <div class="text-center ml-3" v-if="selected_country.id === 'OTHER'">
              <v-btn class="mt-3" color="primary" variant="elevated" href="https://ww2.unipark.de/uc/SOPROS_athlete_ww/"
                target="_blank">Jump to Global Athlete Survey Toolkit</v-btn>
            </div>
          </v-card>
        </v-col>
      </v-row>
      <v-row v-if="selected_country.id !== 'EMPTY' && selected_country.id !== 'OTHER'">
        <v-col cols="12">
          <v-card class="py-4" color="surface-variant" append-icon="mdi-chat-question" rounded="lg" variant="outlined">

            <template #title>
              <h2 class="text-h5 font-weight-bold">Get started</h2>
            </template>

            <div class="mr-5 ml-5 mb-3">
              The Tool asks you some simple questions which refer to your social status and your membership(s) as an
              elite athlete. Based on the information you provide an algorithm calculates your personal social
              protection situation.
              <br></br>
              Your personal outcome will be shown further down the page when checking at least one of the questions.

              <div class="mt-3 mb-5  text-subtitle-2 text-center">
                <v-dialog max-width="700">
                  <template v-slot:activator="{ props: activatorProps }">
                    <v-btn prepend-icon="mdi-information-outline" color="primary" variant="elevated"
                      v-bind="activatorProps">
                      More information and instructions
                    </v-btn>
                  </template>

                  <template v-slot:default="{ isActive }">
                    <v-card title="Information and Instructions">
                      <v-card-text>
                        <b>Scope of the Tool:</b> Everybody is invited to use this Tool. However, it is specifically
                        developed for elite athletes in Olympic sports. National laws and policies have been analysed to
                        design an algorithm which calculates your personal social protection situation. Policies and
                        measures from actors at lower levels (e.g., regional or local) and measures only applicable to
                        athletes in some sports (e.g., offered by a sport federation) are not integrated into the
                        algorithm. The Athlete Survey Toolkit – see button below the Tool’s output – offers the
                        opportunity to share such individual measures with the project team.
                        <br></br><br></br>
                        While this tool is designed mainly for Olympic athletes, also Paralympic athletes may fill in
                        the questions and participate in the subsequent Athlete Survey. The tool is, however, not able
                        to capture the institutional structures, policies and measures (e.g., by the National Paralympic
                        Committees) from which specific social protection measures for Paralympic athletes arise.
                        <br></br><br></br>
                        For athletes in professional sports, specific rules might apply based on collective agreements.
                        These are also not captured in the Tool’s algorithm.
                        <br></br><br></br>
                        <b>Instructions:</b> All you have to do is to check the switch for each question you answer with
                        “Yes” because it currently applies to you. Your personalised output is calculated and displayed
                        below the question section. You can save your results as a pdf through your browser’s print
                        function and submit your data for the analysis.
                      </v-card-text>

                      <v-card-actions>
                        <v-spacer></v-spacer>
                        <v-btn text="Close" @click="isActive.value = false"></v-btn>
                      </v-card-actions>
                    </v-card>
                  </template>
                </v-dialog>
              </div>
            </div>

            <v-list lines="two">
              <v-list-item v-for="question in questions" :key="question.status_id">
                <div class="text-h6 font-weight-bold">{{ question.question }}</div>
                <div v-html="question.addition"></div>
                <template v-slot:prepend>
                  <v-switch class="mr-3" v-model="checked_questions" color="success" :value="question.status_id"
                    hide-details></v-switch>
                </template>
                <template v-slot:append>
                  <v-icon size="x-large" :icon="getStatusIcon(question.status_id)"></v-icon>
                </template>
              </v-list-item>
            </v-list>

            <h3 class="text-h5 font-weight-bold mt-8 text-center">Disclaimer</h3>
            <div class="ml-3 mt-5">
              Please note that the answers below are for information only and do not provide legal advice. You may wish
              to
              seek legal advice from a legal professional regarding your specific circumstances.
            </div>
          </v-card>
        </v-col>
      </v-row>

      <v-row class="mt-5" v-if="provisions && provisions.length != 0">
        <v-col cols=" 12">
          <v-card class="py-4" color="surface-variant" append-icon="mdi-calculator" rounded="lg" variant="outlined">
            <template #image>
              <v-img position="top right" />
            </template>

            <template #title>
              <h2 class="text-h5 font-weight-bold">Your personal social protection situation</h2>
            </template>
            <div class="mr-5 ml-5 mb-3 text-center">
              <v-dialog max-width="700">
                <template v-slot:activator="{ props: activatorProps }">
                  <v-btn prepend-icon="mdi-information-outline" color="primary" variant="elevated"
                    v-bind="activatorProps">
                    More information and interpretation of the output
                  </v-btn>
                </template>

                <template v-slot:default="{ isActive }">
                  <v-card title="Information and Instructions">
                    <v-card-text>
                      You can now see your current social protection situation. Access to each provision and measure
                      arises from the selected statuses and memberships based on the answered questions.
                      <br></br><br></br>
                      The icons on the right-hand side indicate which status leads to the benefit. You can always move
                      up to the questions section to reassure yourself about the meaning of each icon.
                      <br></br><br></br>
                      There are different types of benefits shown in the outcome which are highlighted by an icon on the
                      left-hand side:
                      <br></br><br></br>
                      <v-icon size="x-large" icon="mdi-cash" /> = Cash benefits
                      <br></br><br></br>
                      <v-icon size="x-large" icon="mdi-handshake" /> = Benefits in kind
                      <br></br><br></br>
                      <v-icon size="x-large" icon="mdi-clock-outline" /> = Leave provisions
                      Icon clock = Leave provisions
                      <br></br><br></br>
                      <v-icon size="x-large" icon="mdi-run" /> = Athlete-specific measure
                    </v-card-text>

                    <v-card-actions>
                      <v-spacer></v-spacer>
                      <v-btn text="Close" @click="isActive.value = false"></v-btn>
                    </v-card-actions>
                  </v-card>
                </template>
              </v-dialog>
            </div>

            <div v-for="gen_provision in generic_provisions" class="ml-3 mt-12 text-subtitle-2">
              <div class="text-h5 font-weight-bold"
                v-if="provisions?.filter(item => item.provision_id === gen_provision.id).length != 0 || !['AII', 'APEN', 'PREG', 'PAR', 'OTHER'].includes(gen_provision.id)">
                {{ gen_provision.name }}
              </div>

              <v-list lines="two"
                v-if="provisions?.filter(item => item.provision_id === gen_provision.id).length != 0 || !['AII', 'APEN', 'PREG', 'PAR', 'OTHER'].includes(gen_provision.id)">
                <div v-for="provision in provisions">
                  <v-list-item v-if="gen_provision.id === provision.provision_id" :key="provision.id">
                    <template v-slot:prepend>
                      <v-icon size="x-large" :icon="getTypeIcon(provision.type_id)"></v-icon>
                    </template>
                    <template v-slot:append>
                      <v-icon size="x-large" :icon="getStatusIcon(provision.status_id)"></v-icon>
                    </template>
                    <v-dialog max-width="700">
                      <template v-slot:activator="{ props: activatorProps }">

                        <div v-bind="activatorProps" class="text-h6 font-weight-bold">{{ provision.name }}
                          <v-icon size="25" icon="mdi-information-slab-circle-outline"></v-icon>
                        </div>
                        <div v-bind="activatorProps" v-html="provision.characteristics"></div>

                      </template>

                      <template v-slot:default="{ isActive }">
                        <v-card :title="provision.name">
                          <v-card-text>
                            <div v-html="provision.characteristics"></div>
                            <br />
                            <br />
                            Additional Information: <div v-html="provision.additions"></div>
                            <br />
                            <br />
                            Legal Source: <div v-html="provision.legal_act"></div>
                          </v-card-text>

                          <v-card-actions>
                            <v-spacer></v-spacer>
                            <v-btn text="Close" @click="isActive.value = false"></v-btn>
                          </v-card-actions>
                        </v-card>
                      </template>
                    </v-dialog>
                  </v-list-item>
                </div>
                <v-list-item
                  v-if="provisions?.filter(item => item.provision_id === gen_provision.id).length == 0 && !['AII', 'APEN', 'PREG', 'PAR', 'OTHER'].includes(gen_provision.id)">
                  <template v-slot:prepend>
                    <v-icon size="x-large" icon="mdi-emoticon-sad-outline"></v-icon>
                  </template>
                  no provisions
                </v-list-item>
              </v-list>
            </div>
            <div class="ml-3 text-left text-body-3 font-weight-light">
              <h3 class="text-h4 font-weight-bold mt-12 text-center">What's next?</h3>
              <div class="mt-2">
                <ol class="ml-5 text-h6">
                  <li>Use the print function of your browser to <b>save</b> your results as a pdf document.</li>
                  <li>Please click on the button "Submit Data For Analysis". This also generates your <b>personal ID</b>
                    which you will need this to start the survey. It will automatically be copied to your clipboard.
                    <div class="ml-3 mt-3 mb-3 text-subtitle-2 text-center">
                      <v-snackbar :timeout="2000" color="success">
                        <template v-slot:activator="{ props: snackbarProps }">
                          <v-dialog max-width="700">
                            <template v-slot:activator="{ props: activatorProps }">
                              <v-btn prepend-icon="mdi-content-save-cog" size="x-large" color="primary"
                                variant="elevated" v-bind="activatorProps">Submit Data for
                                Analysis</v-btn>
                            </template>

                            <template v-slot:default="{ isActive }">
                              <v-card title="Submit Data">
                                <v-card-text>
                                  Please confirm that your <b>responses to the questions reflect your current status</b>
                                  and life circumstances.
                                  <br></br><br></br>
                                  When submitting the data, a <b>unique ID</b> is generated and automatically copied to
                                  your clipboard. You will see a green notification. This ID is required to participate
                                  in the <b>Athlete Survey</b>. Please paste it when requested.
                                </v-card-text>

                                <v-card-actions>
                                  <v-spacer></v-spacer>
                                  <v-btn v-bind="snackbarProps" text="Submit"
                                    @click="postAnswerAndClose(isActive)"></v-btn>
                                  <v-btn text="Cancel" @click="isActive.value = false"></v-btn>
                                </v-card-actions>
                              </v-card>
                            </template>
                          </v-dialog>
                        </template>
                        ID '<strong>{{ answer_id }}</strong>' copied to clipboard
                      </v-snackbar>
                    </div>
                    <h3 class="text-h6 font-weight-bold ml-3 mb-5 text-center">ID: {{ answer_id }}</h3>
                  </li>
                  <li>Please click on "Jump to Athlete Survey" to complete the <b>Athlete Survey</b> and express your
                    opinions
                    and
                    perceptions.
                    <div class="ml-3 mt-5 text-subtitle-2 text-center">
                      <v-btn prepend-icon="mdi-file-document-edit" size="x-large" color="primary" variant="elevated"
                        href="https://ww2.unipark.de/uc/SOPROS_athletes_country" @click="copyAnswerIdToClipboard"
                        target="_blank">Jump to Athlete Survey</v-btn>
                    </div>
                  </li>
                </ol>
              </div>
            </div>
          </v-card>
        </v-col>
      </v-row>

      <v-row>
        <v-col cols="12">
          <v-card class="py-4" color="surface-variant" append-icon="mdi-email-fast-outline" rounded="lg"
            variant="outlined">

            <template #title>
              <h2 class="text-h5 font-weight-bold">Questions or comments?</h2>
            </template>
            <div class="mr-5 ml-5">
              <v-btn color="primary" variant="elevated" href="mailto:sopros@dshs-koeln.de"
                @click="copyAnswerIdToClipboard" target="_blank">Contact Sopros Team</v-btn>
            </div>
          </v-card>
        </v-col>
      </v-row>

      <v-row>
        <v-col cols="12">
          <v-card class="py-4" color="surface-variant" append-icon="mdi-account-group" rounded="lg" variant="outlined">

            <template #title>
              <h2 class="text-h5 font-weight-bold">Disclaimer</h2>
            </template>
            <!-- div class="mr-5 ml-5 text-center">
              <h3 class="text-h6 font-weight-bold mt-6">Coordinator</h3>
              <v-img class="mb-4 mt-4" height="100" src="@/assets/1_DSHS-Logo.jpg" />
              German Sport University Cologne (DE)

              <h3 class="text-h6 font-weight-bold mt-12">Academic Partners</h3>
              <v-img class="mb-4 mt-4" height="100" src="@/assets/EHU.png" />
              Edge Hill University (UK)
              <v-img class="mb-4 mt-4" height="100" src="@/assets/ISG.png" />
              Institute for Sport Governance (PL)
              <v-img class="mb-4 mt-4" height="100" src="@/assets/SEA.png" />
              Sport Evolution Alliance (PT)
              <v-img class="mb-4 mt-4" height="100" src="@/assets/Rijeka.jpg" />
              University of Rijeka, Faculty of Law (HR)

              <h3 class="text-h6 font-weight-bold mt-12">Policy Partners</h3>
              <v-img class="mb-4 mt-4" height="100" src="@/assets/EASE.svg" />
              European Association of Sport Employers (FR)
              <v-img class="mb-4 mt-4" height="100" src="@/assets/EAPA.jpg" />
              European Athletes and Players Association (NL)
              <v-img class="mb-4 mt-4" height="100" src="@/assets/EOA.jpeg" />
              European Olympic Academies (DE)

              <h3 class="text-h6 font-weight-bold mt-12">Associated Partner </h3>
              <v-img class="mb-4 mt-4" height="100" src="@/assets/ILO.svg" />
              International Labour Organization (CH)

            </div> -->

            <div class="ml-5 mt-12">The European Commission's support for the production of this publication does not
              constitute an endorsement of the contents, which reflect the views only of the authors, and the Commission
              cannot be held responsible for any use which may be made of the information contained therein.
            </div>

            <div class="mr-5 ml-5 mt-12">
              <a target="_blank" href="https://www.dshs-koeln.de/index.php?id=19953">Imprint</a>
            </div>
          </v-card>
        </v-col>
      </v-row>

    </v-responsive>
  </v-container>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';
import { useTheme } from 'vuetify';



const questions = ref<[{ status_id: string, question: string, addition: string }]>();

const generic_provisions = ref<[{ id: string, name: string, description: string }]>();
fetch('/api/provisions')
  .then(response => response.json())
  .then(data => generic_provisions.value = data);

const provisions = ref<[{ id: string, name: string, provision_id: string, type_id: string, status_id: string, characteristics: string, legal_act: string, additions: string }] | []>();

function getStates(country: { id: string, name: string }): void {
  fetch('/api/country/' + country.id)
    .then(response => response.json())
    .then(data => questions.value = data.questions.concat(data.questions_athlete));
}


const countries = ref<{ id: string, name: string }[]>([{ id: "EMPTY", name: "please select" }]);
const selected_country = ref<{ id: string, name: string }>(countries.value[0]);
fetch('/api/countries')
  .then(response => response.json())
  .then(data => countries.value = countries.value.concat(data.sort((a: { name: string; }, b: { name: string; }) => a.name.localeCompare(b.name))))
  .then(otherCountry => countries.value = countries.value.concat({ id: "OTHER", name: "Other Country" }));

watch(selected_country, (newItem: { id: string, name: string }, oldItem: { id: string, name: string }) => {
  if (newItem.id != oldItem.id) {
    getStates(newItem)
    provisions.value = []
    checked_questions.value = []
  }
})



function calcProvisions(): void {
  const post_checked_questions = '["' + checked_questions.value.join('", "') + '"]'
  //console.log(post_checked_questions)
  const requestOptions = {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: post_checked_questions
  };
  fetch('/api/calc/' + selected_country.value.id, requestOptions)
    .then(response => response.json())
    .then(data => provisions.value = data);
  //console.log(provisions.value)
}
const checked_questions = ref<string[]>([]);
watch(checked_questions, (newItem, oldItem) => {
  calcProvisions()
})


const answer_id = ref<string>("Your personal ID will be displayed here.")

function copyAnswerIdToClipboard() {
  navigator.clipboard.writeText(answer_id.value)
}

function postAnswer(): void {
  const post_checked_questions = '["' + checked_questions.value.join('", "') + '"]'
  //(post_checked_questions)
  const requestOptions = {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: post_checked_questions
  };
  fetch('/api/answer?country_id=' + selected_country.value.id, requestOptions)
    .then(response => response.json())
    .then(data => answer_id.value = data.id)
    .then(saveAnswerIdToClipboard => navigator.clipboard.writeText(answer_id.value));
}

function postAnswerAndClose(isActive: { value: boolean }): void {
  postAnswer()
  isActive.value = false
}


// switch light dark mode
const theme = useTheme()
function toggleTheme() {
  theme.global.name.value = theme.global.current.value.dark ? 'light' : 'dark'
}

// calc Icons
function getTypeIcon(type_id: string): string {
  let result = "mdi-run";
  if (type_id == "INCOME") {
    result = "mdi-cash";
  }
  else if (type_id == "LUMP") {
    result = "mdi-cash";
  }
  else if (type_id == "MINCOV") {
    result = "mdi-cash";
  }
  else if (type_id == "KIND") {
    result = "mdi-handshake";
  }
  else if (type_id == "LEAVE") {
    result = "mdi-clock-outline";
  }
  return result;
}

function getStatusIcon(type_id: string): string {
  let result = "mdi-torch";
  if (type_id == "CIT") {
    result = "mdi-home";
  }
  else if (type_id == "STU") {
    result = "mdi-account-school";
  }
  else if (type_id == "EMP") {
    result = "mdi-account-tie";
  }
  else if (type_id == "MIN") {
    result = "mdi-account-clock";
  }
  else if (type_id == "FWDL") {
    result = "mdi-hand-back-left-outline";
  }
  else if (type_id == "MIL") {
    result = "mdi-star-circle";
  }
  else if (type_id == "CS") {
    result = "mdi-account-tie-hat";
  }
  else if (type_id == "SELF") {
    result = "mdi-account-star";
  }
  else if (type_id == "DSHBAS") {
    result = "mdi-account-multiple-outline";
  }
  else if (type_id == "DSHTOP") {
    result = "mdi-account-multiple-plus-outline";
  }
  else if (type_id == "LBS") {
    result = "mdi-run";
  }
  else if (type_id == "NOC") {
    result = "mdi-medal-outline";
  }
  else if (type_id == "UKSWCP") {
    result = "mdi-medal-outline";
  }
  else if (type_id == "APA") {
    result = "mdi-account-cash-outline";
  }
  else if (type_id == "EAS") {
    result = "mdi-trophy";
  }
  else if (type_id == "NTM") {
    result = "mdi-account-multiple-outline";
  }
  else if (type_id == "SCM") {
    result = "mdi-run";
  }
  else if (type_id == "OGM") {
    result = "mdi-medal-outline";
  }
  else if (type_id == "PCAT1") {
    result = "mdi-numeric-1-box-outline";
  }
  else if (type_id == "SH") {
    result = "mdi-account-cash-outline";
  }
  else if (type_id == "OGWCM") {
    result = "mdi-medal-outline";
  }
  else if (type_id == "DPM") {
    result = "mdi-arrow-up-bold-box-outline";
  }
  return result;
}

</script>
