<template>
  <v-container class="fill-height">
    <v-responsive class="align-centerfill-height mx-auto" max-width="900">
      <v-img class="mb-4" height="150"
        src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/SiegelUniK%C3%B6ln.svg/1024px-SiegelUniK%C3%B6ln.svg.png" />
      <!-- src="@/assets/logo.png"  alternativ verwenden wenn man ein Logo als asset hat -->

      <div class="text-center">
        <div class="text-body-2 font-weight-light mb-n1">Welcome to</div>

        <h1 class="text-h2 font-weight-bold">SOPROS</h1>
      </div>

      <div class="py-4" />

      <v-row>
        <v-col cols="12">
          <v-card class="py-4" color="surface-variant" append-icon="mdi-rocket-launch-outline" rounded="lg"
            variant="outlined">

            <template #title>
              <h2 class="text-h5 font-weight-bold">Select country</h2>
            </template>

            <v-select v-model="selected_country" :items="countries" item-title="name" item-value="id" label="Select"
              persistent-hint return-object single-line></v-select>
          </v-card>

        </v-col>
      </v-row>


      <v-row>
        <v-col cols="12">
          <v-card class="py-4" color="surface-variant" append-icon="mdi-rocket-launch-outline" rounded="lg"
            variant="outlined">

            <template #title>
              <h2 class="text-h5 font-weight-bold">Get started</h2>
            </template>

            <template #subtitle>
              <div class="text-subtitle-1">
                Check the needed States
              </div>
            </template>

            <v-list lines="two">
              <v-list-item v-for="question in questions" :key="question.status_id">
                <div class="text-h6 font-weight-bold">{{ question.question }}</div>
                {{ question.addition }}
                <template v-slot:prepend>
                  <v-icon size="x-large" :color="getIconColor(question.status_id)" :icon="getIcon(question.status_id)"
                    @click="changeState(question.status_id)"></v-icon>
                </template>
              </v-list-item>
            </v-list>
          </v-card>
        </v-col>
      </v-row>

      <v-row>
        <v-col cols=" 12">
          <v-card class="py-4" color="surface-variant" append-icon="mdi-calculator" rounded="lg" variant="outlined">
            <template #image>
              <v-img position="top right" />
            </template>

            <template #title>
              <h2 class="text-h5 font-weight-bold">Current provisions</h2>
            </template>

            <template #subtitle>
              <div class="text-subtitle-1">
                After each change in 'States' click the button 'CALC'
              </div>
              <v-btn color="primary" variant="elevated" @click=calcProvisions>CALC</v-btn>
            </template>

            <div v-for="gen_provision in generic_provisions " class="ml-3 mt-5 text-subtitle-2">
              {{ gen_provision.name }}
              <v-list lines="two">
                <div v-for="provision in provisions">
                  <v-list-item v-if="gen_provision.id === provision.provision_id" :key="provision.id"
                    :title="provision.name" :subtitle="provision.characteristics">
                  </v-list-item>
                </div>
              </v-list>
            </div>

          </v-card>
        </v-col>
      </v-row>
    </v-responsive>
  </v-container>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';


const apiUrl = 'http://localhost:8000/'
// for dockerimage
//const apiUrl = 'https://abcoden.de/'

const questions = ref<[{ status_id: string, question: string, addition: string }]>();
fetch(apiUrl + 'api/country/GER')
  .then(response => response.json())
  .then(data => questions.value = data.questions);

const generic_provisions = ref<[{ id: string, name: string, description: string }]>();
fetch(apiUrl + 'api/provisions')
  .then(response => response.json())
  .then(data => generic_provisions.value = data);


const countries = ref<{ id: string, name: string }[]>([]);
countries.value = [{ id: "GER", name: "Deutschland" }, { id: "UK", name: "England" }] // TODO: make API call
const selected_country = ref<{ id: string, name: string }>({ id: "GER", name: "Deutschland" });




const checked_questions = ref<string[]>([]);

function hasState(newState: string): boolean {
  return checked_questions.value.includes(newState);
}

function changeState(state: string): void {
  if (hasState(state)) {
    checked_questions.value = checked_questions.value.filter(e => e !== state);
  }
  else {
    checked_questions.value.push(state);
  }
  provisions.value = []
  console.log(checked_questions.value);
}

function getIconColor(state: string): string {
  return (hasState(state) ? "success" : "error")
}

function getIcon(state: string): string {
  return (hasState(state) ? "mdi-check-circle-outline" : "mdi-close-circle-outline")
}

const provisions = ref<[{ id: string, name: string, characteristics: string, provision_id: string }] | []>();
function calcProvisions(): void {
  const post_checked_questions = '["' + checked_questions.value.join('", "') + '"]'
  console.log(post_checked_questions)
  const requestOptions = {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: post_checked_questions
  };
  fetch(apiUrl + 'api/calc/' + selected_country.value.id, requestOptions)
    .then(response => response.json())
    .then(data => provisions.value = data);
  console.log(provisions.value)
}

watch(selected_country, (newItem: { id: string, name: string }, oldItem: { id: string, name: string }) => {
  if (newItem.id != oldItem.id) {
    getStates(newItem)
    provisions.value = []
    checked_questions.value = []
  }

})
function getStates(country: { id: string, name: string }): void {
  fetch(apiUrl + 'api/country/' + country.id)
    .then(response => response.json())
    .then(data => questions.value = data.questions);
}

</script>
