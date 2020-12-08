import React, { useState } from 'react'
import { v4 as uuid } from 'uuid'

import { Entry } from '../'

interface NewEntryProps {
  upsert: (entry: Entry) => Promise<void>
}

export const NewEntry: React.FC<NewEntryProps> = ({ upsert }: NewEntryProps) => {
  const [task, setTask] = useState<string>('')

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (!e.target.value) return setTask('')
    setTask(e.target.value)
  }

  const handleKeyPress = async (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key !== 'Enter') return
    await create()
  }

  const create = async () => {
    if (task === '') return
    await upsert({
      uuid: uuid(),
      account_name: 'todo',
      task,
      checked: false,
      created: 0
    })
    setTask('')
  }

  return (
    <div className="ui raised segment">
      <div className="ui fluid action input">
        <input
          className='ui input'
          type='text'
          placeholder='New Task'
          name='newTask'
          value={task}
          onChange={handleChange}
          onKeyPress={handleKeyPress}>
        </input>
        <button className="ui icon button" id="newTaskBtn" onClick={e => create()}><i className="plus icon"></i></button>
      </div>
    </div>
  )
}
