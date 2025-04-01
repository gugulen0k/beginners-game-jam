extends Area3D


class_name Interactable


# Emitted when Interactor looks at me.
signal focused(interactor: Interactor)
# Emitted when Interactor stops looking at me.
signal unfocused(interactor: Interactor)
# Emitted when Interactor interacts with me.
signal interacted(interactor: Interactor)
