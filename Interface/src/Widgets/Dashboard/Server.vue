<template>
  <div id="server-widget">
    <h1>{{ $t("dashboard.widgets.server.title") }}</h1>
    <div class="row">
      <label>{{ $t("dashboard.widgets.server.name") }}</label>
      <TextInput :value="server.name" name="server-name" @change="updateName" />
    </div>
    <div class="row">
      <label>{{ $t("dashboard.widgets.server.ip") }}</label>
      <IPInput
        :ip="server.ip.v4"
        @change="({ ip, valid }) => updateIp({ ip: { v4: ip }, valid })"
      />
    </div>
    <div class="row">
      <label>{{ $t("dashboard.widgets.server.hostname") }}</label>
      <TextInput
        :value="server.hostname"
        name="server-hostname"
        id="server-hostname"
        @change="updateHostname"
      />
    </div>
    <div class="row">
      <label>{{ $t("dashboard.widgets.server.port") }}</label>
      <NumberInput
        name="server-port"
        :value="server.port"
        @change="updatePort"
        :validate="validatePort"
        :invalidMessage="$t('warnings.serverPort')"
        placeholder="1024-65636"
      />
    </div>
    <div class="row">
      <label>{{ $t("dashboard.widgets.server.subnet") }}</label>
      <TextInput
        :value="server.subnet.v4"
        name="server-subnet-v4"
        id="server-subnet-v4"
        @change="(subnet) => updateSubnet({ v4: subnet })"
      />
    </div>
    <Button id="download" @click="downloadConfig" v-if="server.config">
      {{ $t("dashboard.widgets.server.download") }}
    </Button>
  </div>
</template>

<script>
import NumberInput from "components/Inputs/Number";
import TextInput from "components/Inputs/Text";
import IPInput from "components/Inputs/IP";
import Button from "shared-components/Button";
import { downloadText } from "../../lib/download";

export default {
  components: { NumberInput, IPInput, Button, TextInput },
  computed: {
    server() {
      return this.$store.state.server;
    },
  },
  methods: {
    downloadConfig() {
      const config = this.server.config;
      downloadText(config, `server.conf`);
    },
    updateHostname(hostname) {
      this.$store.dispatch("updateServer", { hostname });
    },
    updateSubnet({ v4, v6 }) {
      if (v4) {
        this.$store.dispatch("updateServer", {
          subnet: { ...this.server.subnet, v4 },
        });
      }
      if (v6) {
        this.$store.dispatch("updateServer", {
          subnet: { ...this.server.subnet, v6 },
        });
      }
    },
    updateName(name) {
      this.$store.dispatch("updateServer", { name });
    },
    updateIp({ ip, valid }) {
      if (valid) {
        this.$store.dispatch("updateServer", { ip });
        this.blocked = false;
      } else {
        this.blocked = true;
      }
    },
    validatePort(port) {
      return port > 1024 && port < 65636;
    },
    updatePort(port) {
      this.$store.dispatch("updateServer", { port });
      this.blocked = false;
    },
  },
};
</script>

<style lang="scss" scoped>
.row {
  width: 100%;
  margin-left: auto;
  display: flex;
  justify-content: space-between;
  padding: $spacing-small 0;
}

#download {
  &.button {
    max-width: 20rem;
    margin-left: auto;
    margin-right: auto;
  }
}
</style>
