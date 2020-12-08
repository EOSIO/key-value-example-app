import { Api } from 'eosjs'
import { Entry } from './'

const getbyaccname = async (api: Api) => {
  return api.transact({
    actions: [{
      account: 'todo',
      name: 'getbyaccname',
      authorization: [{
        actor: 'todo',
        permission: 'active',
      }],
      data: {
        account_name: 'todo'
      }
    }]
  }, {
    blocksBehind: 3,
    expireSeconds: 30
  }) as any
}

const upsert = async (api: Api, entry: Entry) => {
  return api.transact({
    actions: [{
      account: 'todo',
      name: 'upsert',
      authorization: [{
        actor: 'todo',
        permission: 'active',
      }],
      data: entry
    }]
  }, {
    blocksBehind: 3,
    expireSeconds: 30
  }) as any
}

const del = async (api: Api, uuid: string) => {
  return api.transact({
    actions: [{
      account: 'todo',
      name: 'del',
      authorization: [{
        actor: 'todo',
        permission: 'active',
      }],
      data: {
        uuid
      }
    }]
  }, {
    blocksBehind: 3,
    expireSeconds: 30
  }) as any
}

export default {
  getbyaccname,
  upsert,
  del,
}