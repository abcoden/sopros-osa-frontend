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
        <iframe class="mt-5" width="560" height="315" src="https://www.youtube.com/embed/hCribgzayYo" frameborder="0"
          allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
        <div class="ml-3 mt-5 mb- text-subtitle-2 text-center">

          <v-btn class="ml-5" color="primary" variant="elevated" href="https://ww2.unipark.de/uc/SOPROS_athlete_ww/"
            @click="copyAnswerIdToClipboard" target="_blank">Jump to Organizazion Survey</v-btn>
        </div>
      </div>

      <div class="text-left text-body-3 font-weight-light">
        <div class="mt-2">This Self-Assessment Tool was developed within the
          EU-funded Erasmus+ Project “Assessing, Evaluating and Implementing Athletes' Social Protection in Olympic
          Sports – SOPROS”. The project’s aim is to assess and evaluate the current social protection situation of elite
          athletes
          in Europe.</div>
        <div class="mt-2">Learn more about the SOPROS Project <a target="_blank"
            href="https://www.dshs-koeln.de/iesf/sopros">here</a>.
        </div>
        <div class="mt-2">Social protection affects our daily lives. Yet, we are often
          not aware of the details of our individual
          situation, nor about our actual social protection entitlements. The Tool offers you the possibility to
          self-assess your current social protection situation as an elite athlete in your country.
        </div>

        <h3 class="text-h5 font-weight-bold mt-5 text-center">Social Protection</h3>

        <div class="mt-2">According to the International Labour Organization and the
          European Union, social protection is a human right. You can learn more about social protection <a
            target="_blank"
            href="https://www.dshs-koeln.de/en/institute-of-european-sport-development-and-leisure-studies/research-projects/ongoing-projects/sopros/resources-on-social-protection">here</a>.
        </div>
        <div class="mt-2">As an elite athlete, your social protection situation is
          determined by two components:</div>

        <h4 class="text-h7 font-weight-bold mt-5 ml-5">Statutory provisions</h4>
        <div class="mt-2">The national laws of your country determine your social protection situation. These provisions
          <u>depend on your social status</u> under national law, for example as a resident, employee, self-employed
          person, or
          elite athlete. International organisations have developed a catalogue of 10 statutory provisions of social
          protection to which everyone should have access.
        </div>

        <h4 class="text-h7 font-weight-bold mt-5 ml-5">Athlete-specific measures</h4>
        <div class="mt-2">Governments and private sport organisations develop policies that <u>only apply to elite
            athletes</u>. These measures may depend on your membership in a national team or cadre, and your personal
          contractual relationships with the stakeholders running elite sport programmes. Athlete-specific measures
          include a specific accident or injury insurance, pregnancy and maternity/paternity policies, specific athlete
          pensions or retirement funds and other measures that are in place to protect you against specific risks
          associated with your sporting practice and changing life circumstances.</div>
      </div>

      <div class="py-4" />

      <v-row>
        <v-col cols="12">
          <v-card class="py-4" color="surface-variant" append-icon="mdi-earth" rounded="lg" variant="outlined">

            <template #title>
              <h2 class="text-h5 font-weight-bold">Select country</h2>
            </template>
            <div class="mr-5 ml-5">
              Please select the country which you represent as an elite athlete.
            </div>

            <v-select v-model="selected_country" :items="countries" item-title="name" item-value="id" label="Select"
              persistent-hint return-object single-line></v-select>
          </v-card>
        </v-col>
      </v-row>


      <v-row v-if="selected_country.id !== 'EMPTY'">
        <v-col cols="12">
          <v-card class="py-4" color="surface-variant" append-icon="mdi-chat-question" rounded="lg" variant="outlined">

            <template #title>
              <h2 class="text-h5 font-weight-bold">Get started</h2>
            </template>

            <div class="mr-5 ml-5 mb-3">
              The Tool asks you some simple
              questions which refer to your social status and your membership(s) as an elite athlete. Based on the
              information you provide an algorithm calculates your personal social protection situation.
              <br></br>
              If you click on the outcome for each provision, further information can be accessed.
            </div>

            <v-list lines="two">
              <v-list-item v-for="question in questions" :key="question.status_id">
                <div class="text-h6 font-weight-bold">{{ question.question }}</div>
                {{ question.addition }}
                <template v-slot:prepend>
                  <v-switch class="mr-3" v-model="checked_questions" color="success" :value="question.status_id"
                    hide-details></v-switch>
                </template>
                <template v-slot:append>
                  <v-icon size="x-large" :icon="getStatusIcon(question.status_id)"></v-icon>
                </template>
              </v-list-item>
            </v-list>
          </v-card>
        </v-col>
      </v-row>

      <v-row class="mt-5" v-if="provisions && provisions.length != 0">
        <v-col cols=" 12">
          <v-card class="py-4" color="surface-variant" append-icon="mdi-calculator" rounded="lg" variant="outlined">
            <template #image>
              <v-img position="top right" />
            </template>

            <h3 class="text-h5 font-weight-bold mt-3 text-center">Disclaimer</h3>
            <div class="ml-3 mt-5">
              Please note that the output of the Tools does not offer legal counsel. Your entitlements to certain
              provisions
              and
              measures may depend on individual factors which cannot be captured by the Tool. Professional counsel and
              advise may
              be required.
            </div>

            <h3 class="text-h5 font-weight-bold mt-16 text-center">In your current situation, you have access to:</h3>

            <div v-for="gen_provision in generic_provisions" class="ml-3 mt-12 text-subtitle-2">
              <div class="text-h4 font-weight-bold"
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
              <div class="text-h6 text-center mt-8">
                Please use the print function of your browser to save your results as a pdf document.
              </div>
              <h3 class="text-h4 font-weight-bold mt-12 text-center">Filling in the Athlete-Survey</h3>
              <div class="mt-2">
                After having read your personal results, you have the chance to use our Survey to paint an even more
                comprehensive
                picture about your social protection situation and to share your personal views about it. Through your
                participation
                in our Survey, you contribute to the identification of existing gaps and the development of new social
                protection
                measures. Ultimately, you support the project team’s endeavour to improve athletes’ welfare in your
                country
                and
                beyond.
              </div>

              <div class="ml-3 mt-5 text-subtitle-2 text-center">
                <v-snackbar :timeout="2000" color="success">
                  <template v-slot:activator="{ props: snackbarProps }">
                    <v-dialog max-width="700">
                      <template v-slot:activator="{ props: activatorProps }">
                        <v-btn color="primary" variant="elevated" v-bind="activatorProps">Save provisions for
                          Analysis</v-btn>
                      </template>

                      <template v-slot:default="{ isActive }">
                        <v-card title="Save Provisions">
                          <v-card-text>
                            Your selected states an provisions will be saved for analysis.
                            An ID is generated, which should be used for the survey
                          </v-card-text>

                          <v-card-actions>
                            <v-spacer></v-spacer>
                            <v-btn v-bind="snackbarProps" text="Submit" @click="postAnswerAndClose(isActive)"></v-btn>
                            <v-btn text="Cancel" @click="isActive.value = false"></v-btn>
                          </v-card-actions>
                        </v-card>
                      </template>
                    </v-dialog>
                  </template>
                  ID '<strong>{{ answer_id }}</strong>' copied to clipboard
                </v-snackbar>
              </div>
              <div class="ml-3 mt-5 text-subtitle-2 text-center">
                <v-btn color="primary" variant="elevated" href="https://ww2.unipark.de/uc/SOPROS_athletes_country"
                  @click="copyAnswerIdToClipboard" target="_blank">Jump to Survey</v-btn>
              </div>
              <h3 class="text-h6 font-weight-bold mt-5 text-center">ID: {{ answer_id }}</h3>
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


const countries = ref<{ id: string, name: string }[]>([]);
const selected_country = ref<{ id: string, name: string }>({ id: "EMPTY", name: "no or other Country" });
fetch('/api/countries')
  .then(response => response.json())
  .then(data => countries.value = data);

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


const answer_id = ref<string>("Click the button 'SAVE PROVISIONS FOR ANALYSIS' to generate your personal ID")

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
    result = "mdi-account-cash-outline";
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
  return result;
}

</script>
