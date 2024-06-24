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
            <template #image>
              <v-img position="top right" />
            </template>

            <template #title>
              <h2 class="text-h5 font-weight-bold">Get started</h2>
            </template>

            <template #subtitle>
              <div class="text-subtitle-1">
                Check the needed States
              </div>
            </template>

            <!-- v-overlay opacity=".12" scrim="primary" contained model-value persistent /> -->

            <v-list lines="two">
              <v-list-item v-for="question in questions" :key="question.status_id" :title="question.question"
                :subtitle="question.addition">
                <template v-if="hasState(question.status_id)" v-slot:prepend>
                  <v-icon size="x-large" color="success" icon="mdi-check-circle-outline"
                    @click="removeState(question.status_id)"></v-icon>
                </template>
                <template v-else v-slot:prepend>
                  <v-icon size="x-large" color="error" icon="mdi-close-circle-outline"
                    @click=addState(question.status_id)></v-icon>
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

            <v-list lines="two">
              <v-list-item v-for="provision in provisions" :key="provision.id" :title="provision.name"
                :subtitle="provision.characteristics">
              </v-list-item>
            </v-list>
          </v-card>
        </v-col>
      </v-row>
    </v-responsive>
  </v-container>
</template>

<script setup lang="ts">
import { ref } from 'vue';


const questions = ref<[{ status_id: string, question: string, addition: string }]>();
fetch('http://localhost:8000/api/country/GER')
  .then(response => response.json())
  .then(data => questions.value = data.questions);

const checked_questions = ref<string[]>([]);

function addState(newState: string): void {
  checked_questions.value.push(newState);
  provisions.value = []
  console.log(checked_questions.value);
}

function removeState(newState: string): void {
  checked_questions.value = checked_questions.value.filter(e => e !== newState);
  provisions.value = []
  console.log(checked_questions.value);
}

function hasState(newState: string): boolean {
  return checked_questions.value.includes(newState);
}

const provisions = ref<[{ id: string, name: string, characteristics: string }] | []>();
function calcProvisions(): void {
  const post_checked_questions = '["' + checked_questions.value.join('", "') + '"]'
  console.log(post_checked_questions)
  const requestOptions = {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: post_checked_questions
  };
  fetch('http://localhost:8000/api/calc/GER', requestOptions)
    .then(response => response.json())
    .then(data => provisions.value = data);
  console.log(provisions.value)
}

</script>
