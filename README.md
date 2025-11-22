# AI-Persistent-Virtual-World
AI-Persistent-Virtual-World---demo
# AI-Persistent-Virtual-World  
**A Research-Oriented Multi-Agent Simulation Prototype Built in Godot**

This project is an experimental **persistent virtual world** designed to explore how autonomous agents (NPCs) can exhibit adaptive, goal-driven, and emergent behaviors inside a simulated environment.  
The project supports my long-term research direction in **multi-agent systems**, **game AI**, and **simulation-based behavior modeling** for future PhD studies.

---

## 🎯 1. Overview

**AI-Persistent-Virtual-World** is a sandbox environment where multiple agents operate independently based on:
- their internal needs (hunger, energy, social),
- real-time perception of the world,
- decision-making algorithms (FSM / Utility AI), and
- interaction with other agents and environmental objects.

The world is **persistent**, meaning agents continuously act, update state, and adapt over time—creating a miniature ecosystem for observing AI behavior.

---

## 🧠 2. Research Motivation

This prototype functions as a small-scale research environment to investigate:

**Agent behavior modeling**  
  How rule-based, utility-driven, or learning-based systems lead to different patterns of behavior.

**Emergent multi-agent dynamics**  
  Competition, cooperation, avoidance, crowd behavior, or resource-driven interaction.

**Environment influence**  
  How world layout, resource placement, or constraints shape agent decisions.

**AI in simulation/game contexts**  
  Demonstrating technical depth relevant to intelligent NPCs and game/simulation research in a PhD application.

This project is **not only a game demo**—it is a **research testbed**.



## 🏗️ 3. System Architecture

### Key Components

- **Agent.gd**  
  Base agent with movement, sensing, and state variables.

- **NeedsComponent.gd**  
  Models hunger, energy, social needs that decay over time.

- **DecisionSystem.gd**  
  Utility-based selector or finite-state-machine logic.

- **Environment.gd**  
  Handles world objects, resources, and interactions.

- **Logger.gd**  
  Outputs behavior logs for later analysis or visualization.

---

## 🧩 4. Features (Current & Planned)

### ✔ Implemented / In Progress
- Multiple agents acting autonomously  
- Basic perception system (vision radius)  
- FSM or utility-based decision-making  
- World with interactable objects (food, resting spots)  
- Behavior logging to file  
- Persistent simulation loop

### 🔧 Planned Extensions
- Agent-to-agent communication  
- Social behavior modeling  
- Reinforcement learning agent variant  
- Neural-based decision modules  
- Long-term memory for agents  
- Dynamic weather/time cycles  
- Analytics dashboard for behavior data

---

## 🚀 5. Running the Project

1. Install **Godot 4.x**  
2. Clone this repository:
   ```bash
   git clone https://github.com/Patrick-GChen/AI-Persistent-Virtual-World.git


