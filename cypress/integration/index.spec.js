describe('Key-Value-Example', () => {

  it('Default State', () => {
    cy.visit('http://localhost:8080')
    cy.wait(2000)
    cy.get('#list').children().should('have.length', 3)
  })

  it('Add New Task', () => {
    cy.visit('http://localhost:8080')
    cy.get('input[name="newTask"]').clear().type('New Task')
    cy.get('#newTaskBtn').click()
    cy.wait(2000)
    cy.get('#list').children().should('have.length', 4)
  })

  it('Rename Task', () => {
    cy.visit('http://localhost:8080')
    cy.wait(2000)
    cy.get('#list').children().last().within(() => {
      cy.get('input[name="task"]').click()
      cy.get('input[name="task"]').clear().type('Changed Task Name')
      cy.get('#cancelBtn').click()
      cy.get('input[name="task"]').should('have.value', 'New Task')
      cy.get('input[name="task"]').click()
      cy.get('input[name="task"]').clear().type('Changed Task Name')
      cy.get('#saveBtn').click()
      cy.wait(2000)
      cy.get('input[name="task"]').should('have.value', 'Changed Task Name')
    })
  })

  it('Mark Task Completed', () => {
    cy.visit('http://localhost:8080')
    cy.wait(2000)
    cy.get('#list').children().last().within(() => {
      cy.get('input[type="checkbox"]').click()
      cy.wait(2000)
      cy.get('input[name="task"]').should('have.css', 'text-decoration', 'line-through solid rgba(0, 0, 0, 0.87)')
    })
  })

  it('Delete Task', () => {
    cy.visit('http://localhost:8080')
    cy.wait(2000)
    cy.get('#list').children().last().within(() => {
      cy.get('#deleteBtn').click()
    })
    cy.wait(2000)
    cy.get('#list').children().should('have.length', 3)
  })
})
