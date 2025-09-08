# app/models/assessment.rb
class Assessment < ApplicationRecord
  validates :name, presence: true, if: :step_10_or_later?
  validates :age, presence: true, numericality: { greater_than: 0 }, if: :step_10_or_later?
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, if: :step_10_or_later?
  validates :phone_number, format: { with: /\A[\d\s\-\(\)]{6,15}\z/ }, allow_blank: true, if: :step_10_or_later?
  validates :phone_country_code, presence: true, if: -> { phone_number.present? }
  validates :privacy_consent, acceptance: true, if: :step_10_or_later?

  # Exercise validations based on current step
  validates :standing_spinal_flexion_test, inclusion: { in: 0..3 }, if: :step_1_or_later?
  validates :arms_overhead, inclusion: { in: 0..3 }, if: :step_2_or_later?
  validates :spine_rotation_right, inclusion: { in: 0..3 }, if: :step_3_or_later?
  validates :spine_rotation_left, inclusion: { in: 0..3 }, if: :step_4_or_later?
  validates :deep_squat, inclusion: { in: 0..3 }, if: :step_5_or_later?
  validates :hands_behind_back_right, inclusion: { in: 0..3 }, if: :step_6_or_later?
  validates :hands_behind_back_left, inclusion: { in: 0..3 }, if: :step_7_or_later?
  validates :straight_leg_raise_right, inclusion: { in: 0..3 }, if: :step_8_or_later?
  validates :straight_leg_raise_left, inclusion: { in: 0..3 }, if: :step_9_or_later?

  attr_accessor :current_step

  COUNTRY_CODES = [
    { code: "+39", country: "🇮🇹 Italia", flag: "🇮🇹" },
    { code: "+41", country: "🇨🇭 Svizzera", flag: "🇨🇭" },
    { code: "+33", country: "🇫🇷 Francia", flag: "🇫🇷" },
    { code: "+49", country: "🇩🇪 Germania", flag: "🇩🇪" },
    { code: "+43", country: "🇦🇹 Austria", flag: "🇦🇹" },
    { code: "+34", country: "🇪🇸 Spagna", flag: "🇪🇸" },
    { code: "+351", country: "🇵🇹 Portogallo", flag: "🇵🇹" },
    { code: "+31", country: "🇳🇱 Paesi Bassi", flag: "🇳🇱" },
    { code: "+32", country: "🇧🇪 Belgio", flag: "🇧🇪" },
    { code: "+44", country: "🇬🇧 Regno Unito", flag: "🇬🇧" },
    { code: "+1", country: "🇺🇸 Stati Uniti", flag: "🇺🇸" },
    { code: "+1", country: "🇨🇦 Canada", flag: "🇨🇦" },
    { code: "+61", country: "🇦🇺 Australia", flag: "🇦🇺" },
    { code: "+81", country: "🇯🇵 Giappone", flag: "🇯🇵" },
    { code: "+86", country: "🇨🇳 Cina", flag: "🇨🇳" },
    { code: "+91", country: "🇮🇳 India", flag: "🇮🇳" },
    { code: "+55", country: "🇧🇷 Brasile", flag: "🇧🇷" },
    { code: "+52", country: "🇲🇽 Messico", flag: "🇲🇽" },
    { code: "+54", country: "🇦🇷 Argentina", flag: "🇦🇷" },
    { code: "+7", country: "🇷🇺 Russia", flag: "🇷🇺" }
  ].freeze

  STEPS = {
    1 => { name: "Standing Spinal Flexion Test", icon: "🩻" },
    2 => { name: "Braccia Sopra", icon: "🙆‍♂️" },
    3 => { name: "Rotazione Dx", icon: "↗️" },
    4 => { name: "Rotazione Sx", icon: "↖️" },
    5 => { name: "Squat", icon: "🏋️‍♂️" },
    6 => { name: "Mani Diet🩻ro Dx", icon: "🤲" },
    7 => { name: "Mani Dietro Sx", icon: "🤲" },
    8 => { name: "Gamba Dx", icon: "🦵" },
    9 => { name: "Gamba Sx", icon: "🦵" },
    10 => { name: "Dati Personali", icon: "👤" }
  }.freeze

EXERCISES = {
  1 => {
    title: "Flesso-estensione in avanti (da in piedi)",
    description: "Piedi uniti, gambe tese, fletti il busto in avanti cercando di toccare il pavimento con le mani",
    field: :standing_spinal_flexion_test,
    criteria: {
      0 => { text: "Mani sopra le ginocchia", image_url: "https://picsum.photos/200?random=1" },
      1 => { text: "Mani alle tibie",         image_url: "https://picsum.photos/200?random=2" },
      2 => { text: "Mani alle caviglie",      image_url: "https://picsum.photos/200?random=3" },
      3 => { text: "Mani a terra",            image_url: "https://picsum.photos/200?random=4" }
    },
    video_url: "https://www.youtube.com/embed/Dpz17mAM848?start=94&end=115&controls=0&modestbranding=1&rel=0&enablejsapi=1",
    time_duration: 21
  },
  2 => {
    title: "Braccia sopra la testa (in piedi)",
    description: "In piedi, alza entrambe le braccia sopra la testa mantenendo la schiena dritta",
    field: :arms_overhead,
    criteria: {
      0 => { text: "Non oltre le spalle",       image_url: "/images/exercises/arms_overhead/0.png" },
      1 => { text: "Con compensi del tronco",   image_url: "/images/exercises/arms_overhead/1.png" },
      2 => { text: "Vicino alle orecchie",      image_url: "/images/exercises/arms_overhead/2.png" },
      3 => { text: "Allineate senza compensi",  image_url: "/images/exercises/arms_overhead/3.png" }
    },
    video_url: "https://www.youtube.com/embed/example2"
  },
  3 => {
    title: "Rotazione globale del rachide - Destra",
    description: "In piedi, ruota il corpo verso destra mantenendo i piedi fermi",
    field: :spine_rotation_right,
    criteria: {
      0 => { text: "Rotazione limitata",            image_url: "https://picsum.photos/200?random=5" },
      1 => { text: "Ruoto 90°",                      image_url: "https://picsum.photos/200?random=6" },
      2 => { text: "Quasi dietro 135°",             image_url: "https://picsum.photos/200?random=7" },
      3 => { text: "Ruoto completamente dietro 180°", image_url: "https://picsum.photos/200?random=8" }
    },
    video_url: "https://www.youtube.com/embed/example3"
  },
  4 => {
    title: "Rotazione globale del rachide - Sinistra",
    description: "In piedi, ruota il corpo verso sinistra mantenendo i piedi fermi",
    field: :spine_rotation_left,
    criteria: {
      0 => { text: "Rotazione limitata",            image_url: "https://picsum.photos/200?random=9" },
      1 => { text: "Ruoto 90°",                      image_url: "https://picsum.photos/200?random=10" },
      2 => { text: "Quasi dietro 135°",             image_url: "https://picsum.photos/200?random=11" },
      3 => { text: "Ruoto completamente dietro 180°", image_url: "https://picsum.photos/200?random=12" }
    },
    video_url: "https://www.youtube.com/embed/example4"
  },
  5 => {
    title: "Squat profondo (a corpo libero)",
    description: "Scendi in squat il più possibile mantenendo l'equilibrio senza appoggi",
    field: :deep_squat,
    criteria: {
      0 => { text: "Non scende",       image_url: "https://picsum.photos/200?random=13" },
      1 => { text: "Instabile",         image_url: "https://picsum.photos/200?random=14" },
      2 => { text: "Quasi a fondo",     image_url: "https://picsum.photos/200?random=15" },
      3 => { text: "Fondo stabile",     image_url: "https://picsum.photos/200?random=16" }
    },
    video_url: "https://www.youtube.com/embed/example5"
  },
  6 => {
    title: "Mani dietro la schiena (destra sopra)",
    description: "Porta la mano destra dall'alto e la sinistra dal basso dietro la schiena",
    field: :hands_behind_back_right,
    criteria: {
      0 => { text: "Distanza >20 cm",  image_url: "https://picsum.photos/200?random=17" },
      1 => { text: "Distanza 10-20 cm", image_url: "https://picsum.photos/200?random=18" },
      2 => { text: "Distanza 5-10 cm",  image_url: "https://picsum.photos/200?random=19" },
      3 => { text: "Le mani si toccano", image_url: "https://picsum.photos/200?random=20" }
    },
    video_url: "https://www.youtube.com/embed/example6"
  },
  7 => {
    title: "Mani dietro la schiena (sinistra sopra)",
    description: "Porta la mano sinistra dall'alto e la destra dal basso dietro la schiena",
    field: :hands_behind_back_left,
    criteria: {
      0 => { text: "Distanza >20 cm",  image_url: "https://picsum.photos/200?random=21" },
      1 => { text: "Distanza 10-20 cm", image_url: "https://picsum.photos/200?random=22" },
      2 => { text: "Distanza 5-10 cm",  image_url: "https://picsum.photos/200?random=23" },
      3 => { text: "Le mani si toccano", image_url: "https://picsum.photos/200?random=24" }
    },
    video_url: "https://www.youtube.com/embed/example7"
  },
  8 => {
    title: "Sollevamento gamba tesa - Destra",
    description: "Sdraiato supino, solleva la gamba destra tesa il più possibile",
    field: :straight_leg_raise_right,
    criteria: {
      0 => { text: "Meno di 45°", image_url: "https://picsum.photos/200?random=25" },
      1 => { text: "45-75°",     image_url: "https://picsum.photos/200?random=26" },
      2 => { text: "75-89°",     image_url: "https://picsum.photos/200?random=27" },
      3 => { text: "90° o più senza dolore", image_url: "https://picsum.photos/200?random=28" }
    },
    video_url: "https://www.youtube.com/embed/example8"
  },
  9 => {
    title: "Sollevamento gamba tesa - Sinistra",
    description: "Sdraiato supino, solleva la gamba sinistra tesa il più possibile",
    field: :straight_leg_raise_left,
    criteria: {
      0 => { text: "Meno di 45°", image_url: "https://picsum.photos/200?random=29" },
      1 => { text: "45-75°",     image_url: "https://picsum.photos/200?random=30" },
      2 => { text: "75-89°",     image_url: "https://picsum.photos/200?random=31" },
      3 => { text: "90° o più senza dolore", image_url: "https://picsum.photos/200?random=32" }
    },
    video_url: "https://www.youtube.com/embed/example9"
  }
}.freeze



  def full_phone_number
    return nil if phone_number.blank?
    "#{phone_country_code} #{phone_number}"
  end

  def country_flag
    return "🇮🇹" if phone_country_code.blank?
    COUNTRY_CODES.find { |c| c[:code] == phone_country_code }&.dig(:flag) || "🌍"
  end

  def total_score
    [
      standing_spinal_flexion_test, arms_overhead, spine_rotation_right, spine_rotation_left,
      deep_squat, hands_behind_back_right, hands_behind_back_left,
      straight_leg_raise_right, straight_leg_raise_left
    ].compact.sum
  end

  def mobility_level
    case total_score
    when 0..9
      { level: "Limitata", color: "red", description: "Mobilità limitata → consigliata valutazione individuale" }
    when 10..18
      { level: "Media", color: "yellow", description: "Mobilità media → percorso di gruppo consigliato" }
    when 19..27
      { level: "Buona", color: "green", description: "Buona mobilità → accedi a percorsi avanzati o di mantenimento" }
    end
  end

  def color_class
    case mobility_level[:color]
    when "red"
      "bg-red-100 border-red-500 text-red-800"
    when "yellow"
      "bg-yellow-100 border-yellow-500 text-yellow-800"
    when "green"
      "bg-green-100 border-green-500 text-green-800"
    end
  end

  def progress_percentage(current_step)
    ((current_step.to_f / 10) * 100).round
  end

  def completed_steps
    steps = 0
    steps += 1 if standing_spinal_flexion_test.present?
    steps += 1 if arms_overhead.present?
    steps += 1 if spine_rotation_right.present?
    steps += 1 if spine_rotation_left.present?
    steps += 1 if deep_squat.present?
    steps += 1 if hands_behind_back_right.present?
    steps += 1 if hands_behind_back_left.present?
    steps += 1 if straight_leg_raise_right.present?
    steps += 1 if straight_leg_raise_left.present?
    steps += 1 if name.present? && age.present? && email.present?
    steps
  end

  def is_complete?
    completed_steps == 10
  end

  private

  def step_1_or_later?
    current_step.to_i >= 1
  end

  def step_2_or_later?
    current_step.to_i >= 2
  end

  def step_3_or_later?
    current_step.to_i >= 3
  end

  def step_4_or_later?
    current_step.to_i >= 4
  end

  def step_5_or_later?
    current_step.to_i >= 5
  end

  def step_6_or_later?
    current_step.to_i >= 6
  end

  def step_7_or_later?
    current_step.to_i >= 7
  end

  def step_8_or_later?
    current_step.to_i >= 8
  end

  def step_9_or_later?
    current_step.to_i >= 9
  end

  def step_10_or_later?
    current_step.to_i >= 10
  end
end
