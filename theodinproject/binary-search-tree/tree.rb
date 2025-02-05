require './node'

class Tree
  attr_reader :root

  def initialize(arr)
    arr = arr.sort.uniq
    @root = build_tree(arr)
  end

  def insert(value)
    new_node = Node.new(value)
    root = @root
    while root
      if new_node > root
        root.right ? root = root.right : (return root.right = new_node)
        # ternary operator can be replaced with:
        # return root.right = new_node unless root.right
        # root = root.right
      elsif new_node < root
        root.left ? root = root.left : (return root.left = new_node)
      else
        return puts 'The node already exists in the tree'
      end
    end
  end

  def delete(value, root = @root)
    return root if root.nil?

    if value > root.value
      root.right = delete(value, root.right)
    elsif value < root.value
      root.left = delete(value, root.left)
    else
      root = remove_node(root)
    end
    root
  end

  def find(value, root = @root)
    return if root.nil?

    if value > root.value
      find(value, root.right)
    elsif value < root.value
      find(value, root.left)
    else
      root
    end
  end

  def level_order(node = @root, queue = [], result = [])
    result << node.value
    queue << node.left if node.left
    queue << node.right if node.right
    return result if queue.empty?

    level_order(queue.shift, queue, result)
  end

  def inorder(node = @root, result = [])
    unless node.nil?
      inorder(node.left, result)
      result << node.value
      inorder(node.right, result)
    end
    result
  end

  def preorder(node = @root, result = [])
    unless node.nil?
      result << node.value
      preorder(node.left, result)
      preorder(node.right, result)
    end
    result
  end

  def postorder(node = @root, result = [])
    unless node.nil?
      postorder(node.left, result)
      postorder(node.right, result)
      result << node.value
    end
    result
  end

  def height(node = @root, edges = 0, result = [])
    return if node.nil?

    result << edges
    edges += 1
    height(node.left, edges, result) if node.left
    height(node.right, edges, result) if node.right
    result.max
  end

  def depth(node = @root, edges = 0, parent = @root, result = [])
    return if node.nil?
    return result << edges if parent == node

    edges += 1
    if result.empty?
      depth(node, edges, parent.left, result) if parent.left
      depth(node, edges, parent.right, result) if parent.right
    end
    result[0]
  end

  def balanced?(node = @root)
    return if node.nil? || node.right.nil? || node.left.nil?

    left = height(node.left)
    right = height(node.right)

    return false if (right - left).abs > 1

    balanced?(node.right)
    balanced?(node.left)
    true
  end

  def rebalance
    initialize(level_order)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    if node.right
      pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false)
    end
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    if node.left
      pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true)
    end
  end

  private

  def remove_node(node)
    return node.right if node.left.nil?
    return node.left if node.right.nil?

    # Find the smallest node in the right subtree
    current = node.right
    current = current.left while current.left

    # Copy value of the smallest node
    node.value = current.value

    # Delete node with the smallest value
    node.right = delete(current.value, node.right)
    node
  end

  def build_tree(arr)
    return nil if arr.empty?

    middle = (arr.size - 1) / 2
    root = Node.new(arr[middle])
    root.left = build_tree(arr[0...middle])
    root.right = build_tree(arr[middle + 1..-1])
    root
  end
end
