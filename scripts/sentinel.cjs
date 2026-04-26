#!/usr/bin/env node
const { spawnSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const CONFIG_DIR = path.join(__dirname, '..', 'configs');
const HOOKS_DIR = path.join(__dirname, 'hooks');

function runCommand(cmd, args, options = {}) {
  const result = spawnSync(cmd, args, { encoding: 'utf-8', ...options });
  if (result.error) {
    console.error(`Error executing ${cmd}: ${result.error.message}`);
    process.exit(1);
  }
  return result;
}

const commands = {
  thaw: (configName) => {
    if (!configName) {
      console.error('Error: Configuration name required.');
      process.exit(1);
    }
    const configFile = path.join(CONFIG_DIR, `${configName}.yml`);
    if (!fs.existsSync(configFile)) {
      console.error(`Error: Configuration file ${configFile} not found.`);
      process.exit(1);
    }
    console.log(`Thawing environment: ${configName}...`);
    const result = runCommand('smug', ['start', configName, '--file', configFile, '--detach']);
    if (result.status === 0) {
      console.log(`Success: Environment '${configName}' thawed.`);
    } else {
      console.error(`Error thawing environment: ${result.stderr}`);
    }
  },

  hibernate: (sessionName) => {
    if (!sessionName) {
      console.error('Error: Session name required.');
      process.exit(1);
    }
    console.log(`Hibernating session: ${sessionName}...`);
    
    // Phase 4: Trigger App-Aware Hooks before stopping
    const preHibernateHook = path.join(HOOKS_DIR, 'pre_hibernate.sh');
    if (fs.existsSync(preHibernateHook)) {
      console.log('Running pre-hibernate hooks...');
      runCommand('bash', [preHibernateHook, sessionName]);
    }

    const configFile = path.join(CONFIG_DIR, `${sessionName}.yml`);
    let result;
    if (fs.existsSync(configFile)) {
      result = runCommand('smug', ['stop', sessionName, '--file', configFile]);
    } else {
      console.log(`No declarative config found for '${sessionName}', performing standard hibernation...`);
      result = runCommand('tmux', ['kill-session', '-t', sessionName]);
    }

    if (result.status === 0) {
      console.log(`Success: Session '${sessionName}' hibernated.`);
    } else {
      console.error(`Error hibernating session: ${result.stderr}`);
    }
  },

  jump: (projectPath) => {
    if (!projectPath) {
      console.error('Error: Project path required.');
      process.exit(1);
    }
    console.log(`Jumping to project: ${projectPath}...`);
    const result = runCommand('sesh', ['connect', projectPath]);
    if (result.status === 0) {
      console.log(`Success: Switched to session for '${projectPath}'.`);
    } else {
      console.error(`Error jumping to project: ${result.stderr}`);
    }
  },

  sync: (configName) => {
    if (!configName) {
      console.error('Error: Configuration name required.');
      process.exit(1);
    }
    console.log(`Syncing state for: ${configName}...`);
    // Smug doesn't have a native 'sync', so we 'start' it again.
    // Smug is smart enough to only create missing windows/panes.
    const configFile = path.join(CONFIG_DIR, `${configName}.yml`);
    const result = runCommand('smug', ['start', configName, '--file', configFile, '--detach']);
    if (result.status === 0) {
      console.log(`Success: State synced for '${configName}'.`);
    } else {
      console.error(`Error syncing state: ${result.stderr}`);
    }
  }
};

if (require.main === module) {
  const args = process.argv.slice(2);
  const command = args[0];
  
  if (!command || command === '--help' || command === '-h' || !commands[command]) {
    console.log(`
tmux-sentinel 🛡️

Usage: sentinel <command> [args]

Commands:
  thaw <config>      Restore a session layout from configs/
  hibernate <name>   Save app state and close a session
  jump <path>        Switch to a project directory using sesh
  sync <config>      Sync current tmux state with declarative config
  --help, -h         Show this help menu
    `);
    process.exit(command ? 0 : 1);
  }
  commands[command](...args.slice(1));
}

module.exports = { commands };
